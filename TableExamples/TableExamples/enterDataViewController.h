//
//  enterDataViewController.h
//  TableExamples
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface enterDataViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *petNameField;
@property (strong, nonatomic) TableViewController *parentTableVC;
- (IBAction)done:(id)sender;

@end
