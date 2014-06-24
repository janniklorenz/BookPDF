//
//  BookPDF.h
//
//  Created by Jannik Lorenz on 18.06.14
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookPDFPage;

@interface BookPDF : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UINavigationBarDelegate>



#pragma mark - PDF

/** PDF Document */
@property (readonly) CGPDFDocumentRef PDFDocument;

/** The Current Index, may not correct if to Pages, <<Starts with 1>> */
@property (nonatomic) int currentIndex;

/** PDF Pages Count */
@property (readonly) int totalPages;





#pragma mark - Interface Stuff

/** UINavigation Bar */
@property (readonly) UINavigationBar *navigationBar;

/** UIToolbar, used for fast Page Switch */
@property (readonly) UIToolbar *toolBar;

/** UINavigation Item */
@property (readonly) UINavigationItem *navItem;


/* Hides/ Shows the Interface Controls */
@property (nonatomic) BOOL controlsHidden;





#pragma mark - inits

/** returns an new instance based on the given path */
- (id)initWithPDFAtPath:(NSString *)path;

/** returns an new instance based on the given url */
- (id)initWithPDFAtURL:(NSURL *)url;

/** returns an new instance based on the given data */
- (id)initWithData:(NSData *)data;



@end
