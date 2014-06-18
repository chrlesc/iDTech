//
//  ViewController.h
//  AutoExample
//
//  Created by Chris Lesch on 6/17/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)pressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button;
- (IBAction)pressed2:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button2;

@end
