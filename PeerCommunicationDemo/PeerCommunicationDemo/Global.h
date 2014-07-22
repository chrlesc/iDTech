//
//  Global.h
//  PeerCommunicationDemo
//
//  Created by iD Staff on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"
#import "ConnectionsViewController.h"

@interface Global : NSObject
+(ConnectionManager *)getConnectionManager;
+(NSMutableArray *)getSettingsArray;
+(void)setConnectionsVC:(ConnectionsViewController *)vc;
+(ConnectionsViewController *)getConnectionsVC;
+(NSMutableArray *)getMessageArray;
@end
