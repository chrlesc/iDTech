//
//  ConnectionsViewController.h
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionsViewController : UIViewController
//Browse
- (IBAction)Browse:(id)sender;
//Discovery
@property (strong, nonatomic) IBOutlet UITextField *DiscoveryName;
@property (strong, nonatomic) IBOutlet UISwitch *discoveryModeSwitch;
@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)Discover:(id)sender;
//Disconnect
- (IBAction)Disconnect:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *disconnectBtn;


@end
