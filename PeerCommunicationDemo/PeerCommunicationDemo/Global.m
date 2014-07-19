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
+(ConnectionsViewController *)getConnectionsVC{
    return connectionVC;
}
+(void)setConnectionsVC:(ConnectionsViewController *)vc{
    connectionVC = vc;
}
@end
