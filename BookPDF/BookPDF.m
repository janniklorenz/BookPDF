//
//  BookPDF.m
//
//  Created by Jannik Lorenz on 18.06.14
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import "BookPDF.h"
#import "BookPDFPage.h"

#define THUMBNAIL_BAR_COUNT 8
#define THUMBNAIL_BAR_HEIGHT 100

#define HIDE_ANIMATION_DURATION 0.6

@implementation BookPDF


#pragma mark - inits

- (id)initWithPDFAtURL:(NSURL *)url {
    return [self initWithPDFAtPath:url.absoluteString];
}

- (id)initWithData:(NSData *)data {
    NSLog(@"[ERROR] initWithData not implementet");
    return nil;
}

- (id)initWithPDFAtPath:(NSString *)path {
    
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.doubleSided = NO;
    self.delegate = self;
    self.dataSource = self;
    
    NSURL *pdfUrl = [NSURL URLWithString:path];
    _PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfUrl);
    _totalPages = (int)CGPDFDocumentGetNumberOfPages(_PDFDocument);
    
    
    
    // --- Nav Bar ---
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _navigationBar.barTintColor = [UIColor whiteColor];
    _navigationBar.delegate = self;
    _navigationBar.layer.zPosition = 100;
    
    [self.view addSubview:_navigationBar];
    
    _navItem = [[UINavigationItem alloc] init];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(exit:)];
    _navItem.leftBarButtonItem = doneButton;
    _navigationBar.items = @[ _navItem ];
    
    
    
    // --- Nav Bar ---
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-THUMBNAIL_BAR_HEIGHT, self.view.frame.size.width, THUMBNAIL_BAR_HEIGHT)];
    _toolBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    _toolBar.barTintColor = [UIColor whiteColor];
    _toolBar.layer.zPosition = 100;
    
    [self.view addSubview:_toolBar];
    
    
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSMutableArray *items = [NSMutableArray arrayWithObjects:flexSpace, nil];
    
    
    int max = THUMBNAIL_BAR_COUNT - 1;
    if (max > _totalPages) max = _totalPages;
    
    int add = _totalPages/max;
    
    int i = 0;
    for (int page = 1; i < max; page+=add) { [items addObject: [self getThubnailButtonForPage:page] ]; i++; }
    if (THUMBNAIL_BAR_COUNT < _totalPages) [items addObject: [self getThubnailButtonForPage:_totalPages] ];
    
    [items addObject:flexSpace];
    self.toolBar.items = (NSArray *)items;
    
    
    
    // Tap Recognizer
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeState:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    _currentIndex = 1;
    BookPDFPage *a = [self getBookPDFPageForPage:_currentIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:a, nil];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self updateUIWithPage:_currentIndex];
    
    
    return self;
}

- (UIBarButtonItem *)getThubnailButtonForPage:(int)i {
    UIImage *thumbnail = [self getThumbnailForPage:i];
    thumbnail = [UIImage imageWithCGImage:[thumbnail CGImage] scale:(thumbnail.scale * thumbnail.size.height/(THUMBNAIL_BAR_HEIGHT-4)) orientation:(thumbnail.imageOrientation)];
    
    UIButton *thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thumbnailButton.bounds = CGRectMake( 0, 0, thumbnail.size.width, thumbnail.size.height );
    [thumbnailButton setImage:thumbnail forState:UIControlStateNormal];
    [thumbnailButton addTarget:self action:@selector(switchTo:) forControlEvents:UIControlEventTouchUpInside];
    thumbnailButton.tag = i;
    
    thumbnailButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    thumbnailButton.layer.borderWidth = 0.5;
    
    return [[UIBarButtonItem alloc] initWithCustomView:thumbnailButton];
}




#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    // TODO
    [self.view bringSubviewToFront:_navigationBar];
    [self.view bringSubviewToFront:_toolBar];
}






#pragma mark - navigation bar helper

/** Uses To Get an iOS 7 like nav bar */
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}





#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int i = [(BookPDFPage *)viewController page] - 1;
    
    if (i%2 == 0 || self.viewControllers.count == 1) [self updateUIWithPage:i];
    
    return [self getBookPDFPageForPage:i];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int i = [(BookPDFPage *)viewController page] + 1;
    
    if (i%2 == 0 || self.viewControllers.count == 1) [self updateUIWithPage:i];
    
    return [self getBookPDFPageForPage:i];
}





#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    // TODO
    [self.view bringSubviewToFront:_navigationBar];
    [self.view bringSubviewToFront:_toolBar];
    
    int i = [[self.viewControllers objectAtIndex:0] page] + 1;
    
    if ( UIInterfaceOrientationIsPortrait(orientation) ) {
        pageViewController.doubleSided = NO;
        
        if ( (i<=1) && self.viewControllers.count == 2 )
            i = [[self.viewControllers objectAtIndex:1] page];
        
        else
            i = [[self.viewControllers objectAtIndex:0] page];
        
        BookPDFPage *a = [self getBookPDFPageForPage:i];
        NSArray *viewControllers = [NSArray arrayWithObjects:a, nil];
        
        [a initPDFViewerWithOrientation:orientation];
        
        [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        return UIPageViewControllerSpineLocationMin;
    }
    
    else {
        pageViewController.doubleSided = YES;
        
        BookPDFPage *a = [self getBookPDFPageForPage: [[self.viewControllers objectAtIndex:0] page] ];
        i =  a.page - 1;
        BookPDFPage *b = [self getBookPDFPageForPage:i];
            
        NSArray *viewControllers;
        if ( (i%2==0) && self.viewControllers.count == 1 )
            viewControllers = [NSArray arrayWithObjects:b, a, nil ];
        
        else {
            b = [self getBookPDFPageForPage:i+2];
            viewControllers = [NSArray arrayWithObjects:a, b, nil ];
        }
        
        [a initPDFViewerWithOrientation:orientation];
        [b initPDFViewerWithOrientation:orientation];
        
        [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        return UIPageViewControllerSpineLocationMid;
    }
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    // TODO
    [self.view bringSubviewToFront:_navigationBar];
    [self.view bringSubviewToFront:_toolBar];
}





#pragma mark -  Update the UI

/** Helper Function, used to Update Interface */
- (void)updateUIWithPage:(int)i {
    
    i = [self correctPage:i];
    
    if (self.viewControllers.count == 1) _navItem.title = [NSString stringWithFormat:@"%i von %i", i, _totalPages];
    else {
        NSString *a = @"";
        if ([self validPage:i]) a = [NSString stringWithFormat:@"%i", i];
        
        NSString *b = @"";
        if ([self validPage:i+1] && [self validPage:i]) b = [NSString stringWithFormat:@" - %i", i+1];
        else if ([self validPage:i+1]) b = [NSString stringWithFormat:@"%i", i+1];
        
        _navItem.title = [NSString stringWithFormat:@"%@%@ von %i", a, b, _totalPages];
    }
}

/** Helper Function, gives back if page in in range */
- (BOOL)validPage:(int)i {
    if (i > 0 && i <= _totalPages) return YES;
    return NO;
}

/** Helper Function, correct Page Index For UI */
- (int)correctPage:(int)i {
    if (i > _totalPages) return _totalPages;
    else if (i <= 0) return 0;
    else return i;
}






#pragma mark - IBAction Handelers

/** Trigges a switchPage event with Tag */
- (void)switchTo:(id)sender {
    self.currentIndex = (int)[sender tag];
    self.controlsHidden = NO;
}

/** Invert controlsHidden */
- (void)changeState:(id)sender {
    self.controlsHidden = !_controlsHidden;
}

/** Dismiss View Controller */
- (void)exit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}






#pragma mark - Setter

/* Hides/ Shows the Interface Controls */
- (void)setControlsHidden:(BOOL)controlsHidden {
    if (controlsHidden) {
        [UIView beginAnimations:@"hide" context:NULL];
        [UIView setAnimationDuration:HIDE_ANIMATION_DURATION];
        [_navigationBar setAlpha:0.0];
        [_toolBar setAlpha:0.0];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:@"show" context:NULL];
        [UIView setAnimationDuration:HIDE_ANIMATION_DURATION];
        [_navigationBar setAlpha:1.0];
        [_toolBar setAlpha:1.0];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView commitAnimations];
    }
    _controlsHidden = controlsHidden;
}

/** switch currend page Manually */
- (void)setCurrentIndex:(int)i {
    const int old = [(BookPDFPage *)self.viewControllers.firstObject page];
    if (self.viewControllers.count > 1) [(BookPDFPage *)self.viewControllers.lastObject page];
    
    UIPageViewControllerNavigationDirection dir = UIPageViewControllerNavigationDirectionReverse;
    BOOL animated = YES;
    
    if (old < i) dir = UIPageViewControllerNavigationDirectionForward;
    else if (old == i) animated = NO;
    
    if ( UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ) {
        BookPDFPage *a = [self getBookPDFPageForPage:i];
        NSArray *viewControllers = [NSArray arrayWithObjects:a, nil];
        
        [self setViewControllers:viewControllers direction:dir animated:animated completion:NULL];
    }
    else {
        BookPDFPage *a = [self getBookPDFPageForPage:i  ];
        BookPDFPage *b = [self getBookPDFPageForPage:i+1];
        
        NSArray *viewControllers;
        if ( i%2==0 ) viewControllers = [NSArray arrayWithObjects:a, b, nil ];
        else {
            b = [self getBookPDFPageForPage:i-1];
            viewControllers = [NSArray arrayWithObjects:b, a, nil ];
        }
        
        [self setViewControllers:viewControllers direction:dir animated:animated completion:NULL];
    }
    [self updateUIWithPage:i];
}






#pragma mark - Helper Functions

/** returns a new BookPDFPage with given page, if out of range and %2==1, blank, else nil */
- (BookPDFPage *)getBookPDFPageForPage:(int)p {
    BookPDFPage *a = [[BookPDFPage alloc] initWithPDF:_PDFDocument atPage:p bookStyle:self.doubleSided andFrame:self.view.frame];
    return a;
}

/** Returns a Thumbnal of the Given Page */
- (UIImage *)getThumbnailForPage:(int)page {
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(_PDFDocument, page);
    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    
    UIGraphicsBeginImageContext(pageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetMinX(pageRect),CGRectGetMaxY(pageRect));
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, -(pageRect.origin.x), -(pageRect.origin.y));
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}






@end
