//
//  enterDataViewController.m
//  TableExamples
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "enterDataViewController.h"

@interface enterDataViewController ()

@end

@implementation enterDataViewController

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
- (IBAction)done:(id)sender {
    NSDictionary *dictionary = @{ @"name" : self.nameField.text,
                                  @"pet" : self.petNameField.text
                                  };
    [self.parentTableVC insertNewRow:dictionary];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
