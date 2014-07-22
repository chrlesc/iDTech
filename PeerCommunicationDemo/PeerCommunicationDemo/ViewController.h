//
//  ViewController.h
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>{
    ConnectionManager *manager;
    NSMutableArray *settingsArray;
    NSMutableArray *messageArray;
}
@property (strong, nonatomic) IBOutlet UIView *shadedView;
@property (strong, nonatomic) UITableView *settingsTable;
- (IBAction)PullUpMenu:(id)sender;
- (IBAction)tapToCloseMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *messageTable;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeUp;
@property (strong, nonatomic) IBOutlet UITextField *messageEntered;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end
