//
//  BookPDFPage.h
//
//  Created by Jannik Lorenz on 18.06.14
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PDFScrollView.h"

@class PDFScrollView;

@interface BookPDFPage : UIViewController <UIScrollViewDelegate>


#pragma mark - inits

/** returns a new instance, if the page is in the bounds */
- (id)initWithPDF:(CGPDFDocumentRef)pdf atPage:(int)p bookStyle:(BOOL)book andFrame:(CGRect)frame;





#pragma mark - set up PDF Viewer

/** inits the PDF View, using Status Bar Orientation */
- (void)initPDFViewer;

/** set up PDF View with given Orentation */
- (void)initPDFViewerWithOrientation:(UIInterfaceOrientation)ori;





#pragma mark - PDF (Page)

/** PDF Document */
@property (readonly) CGPDFDocumentRef PDFDocument;


/** PDF Page Scroll View */
@property (readonly) PDFScrollView *pdfScrollView;


/** Current Page <<Starts with 1>> */
@property (readonly) int page;

/** PDF Pages Count */
@property (readonly) int maxPages;


/** book, true if Double Sided */
@property (readonly) BOOL book;





@end
