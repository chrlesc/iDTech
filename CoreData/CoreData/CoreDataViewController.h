//
//  CoreDataViewController.h
//  CoreData
//
//  Created by Neil Smyth on 9/18/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataAppDelegate.h"

@interface CoreDataViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UILabel *status;
- (IBAction)saveData:(id)sender;
- (IBAction)findContact:(id)sender;

@end
