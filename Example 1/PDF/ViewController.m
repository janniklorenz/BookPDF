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

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changePDF:(id)sender {
    NSLog(@"%i", (int)[sender tag]);
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"demo%i", (int)[sender tag]] ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    BookPDF *page = [[BookPDF alloc] initWithPDFAtURL:url];
    [self presentViewController:page animated:YES completion:NULL];
}


@end
