//
//  ViewController.m
//  AutoExample
//
//  Created by Chris Lesch on 6/17/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressed:(id)sender {
    [self.button setTitle:@"A LONG BUTTON TEXT" forState:UIControlStateNormal];
}
- (IBAction)pressed2:(id)sender {
    [self.button2 setTitle:@"A LONG BUTTON TEXT" forState:UIControlStateNormal];
}
@end
