//
//  BookPDFPage.m
//
//  Created by Jannik Lorenz on 18.06.14
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import "BookPDFPage.h"

#define MAXZOOMSCALE 10.0
#define MINZOOMSCALE 0.0

@implementation BookPDFPage


#pragma mark - inits

- (id)initWithPDF:(CGPDFDocumentRef)pdf atPage:(int)p bookStyle:(BOOL)book andFrame:(CGRect)frame {
    _PDFDocument = pdf;
    _book = book;
    _maxPages = (int)CGPDFDocumentGetNumberOfPages(_PDFDocument);
    _page = p;
    
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;

    if (  ( (_page <= -1) || (_page%2 == 0 && _page > _maxPages) ) && book  ) return nil;
    else if (  ( _page <= 0 || _page > _maxPages ) && !book ) return nil;
    
    self = [super initWithNibName:nil bundle:nil];
    
    return self;
}

- (void)initPDFViewer {
    UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
    [self initPDFViewerWithOrientation:ori];
}

- (void)initPDFViewerWithOrientation:(UIInterfaceOrientation)ori {
    if (_maxPages < _page || _page <= 0) { /* Empty Page */ }
    else {
        CGPDFPageRef PDFPage = CGPDFDocumentGetPage(_PDFDocument, _page);
        
        _pdfScrollView = [[PDFScrollView alloc] initWithFrame:self.view.frame];
        
        [_pdfScrollView setPDFPage:PDFPage withOrentation:ori];
        [self.view addSubview:_pdfScrollView];
        
        _pdfScrollView.delegate = self;
        _pdfScrollView.minimumZoomScale = MINZOOMSCALE;
        _pdfScrollView.maximumZoomScale = MAXZOOMSCALE;
        
        _pdfScrollView.userInteractionEnabled = NO;
        _pdfScrollView.bounces = NO;
        
        _pdfScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}




#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPDFViewer];
}

- (void)dealloc {
    _page = 0;
    _pdfScrollView = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _page = 0;
    _pdfScrollView = nil;
}




//#pragma mark UIScrollView delegate methods
//
///*
//   Just forward all delegate messages to _pdfScrollView original implementation
// */
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return [_pdfScrollView viewForZoomingInScrollView:scrollView];
//}
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
//    [_pdfScrollView scrollViewWillBeginZooming:scrollView withView:view];
//}
//
///*
//  Here, also adjust the zooming factors so the overall min/max are guaranteed
// */
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//    [_pdfScrollView scrollViewDidEndZooming:scrollView withView:view atScale:scale];
//    
//    _pdfScrollView.minimumZoomScale /= scale;
//    _pdfScrollView.maximumZoomScale /= scale;
//}



@end