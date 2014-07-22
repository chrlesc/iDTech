//
//  Global.m
//  PeerCommunicationDemo
//
//  Created by iD Staff on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "Global.h"

@implementation Global
static ConnectionManager *manager;
static NSMutableArray *settingsArray;
static NSMutableArray *messageArray;
static ConnectionsViewController *connectionVC;
+(ConnectionManager *)getConnectionManager{
    if(manager == nil){
        manager = [[ConnectionManager alloc] init];
    }
    return manager;
}
+(NSMutableArray *)getSettingsArray{
    if(settingsArray == nil){
        settingsArray = [[NSMutableArray alloc] init];
    }
    return settingsArray;
}
+(NSMutableArray *)getMessageArray{
    if(messageArray == nil){
        messageArray = [[NSMutableArray alloc] init];
    }
    return messageArray;
}
+(ConnectionsViewController *)getConnectionsVC{
    return connectionVC;
}
+(void)setConnectionsVC:(ConnectionsViewController *)vc{
    connectionVC = vc;
}
@end
