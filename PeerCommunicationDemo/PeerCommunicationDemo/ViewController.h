//
//  ViewController.h
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *settingsArray;
}
@property (strong, nonatomic) IBOutlet UIView *shadedView;
@property (strong, nonatomic) UITableView *settingsTable;
- (IBAction)PullUpMenu:(id)sender;
- (IBAction)tapToCloseMenu:(id)sender;

@end
