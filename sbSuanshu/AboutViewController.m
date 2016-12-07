//
//  AboutViewController.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton*)sender {
    if (sender.tag == 101) {
        viewTo.hidden = YES;
    }
    else {
        viewTo.hidden = NO;
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIInterfaceOrientationIsLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
