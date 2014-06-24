//
//  ViewController.m
//  PDF
//
//  Created by Jannik Lorenz on 24.06.14.
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import "ViewController.h"
#import "BookPDF.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)changePDF:(id)sender {
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"pdf"];
//    NSData *dat = [NSData dataWithContentsOfFile:path];
//    BookPDF *page = [[BookPDF alloc] initWithData:dat];
//    [self presentViewController:page animated:YES completion:NULL];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"pdf"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    BookPDF *page = [[BookPDF alloc] initWithPDFAtURL:url];
//    [self presentViewController:page animated:YES completion:NULL];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"demo%i", (int)[sender tag]] ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    BookPDF *page = [[BookPDF alloc] initWithPDFAtURL:url];
    [self presentViewController:page animated:YES completion:NULL];
}


@end
