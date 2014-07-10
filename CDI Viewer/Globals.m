//
//  Globals.m
//  CDI Viewer
//
//  Created by Chris Lesch on 1/15/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "Globals.h"

@implementation Globals
static Globals *instance = nil;

+(Globals *)getInstance{
    @synchronized(self)
    {
        if(instance == nil){
            instance = [Globals new];
            instance.startingDocs = [NSMutableArray arrayWithObjects:@"480432",@"480421",@"480422",@"480361", nil];
        }
    }
    return instance;
}
- (NSString *)documentsBasePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingString:@"/"];
}

/*Determine if the device is Iphone5 with longer screen
* */
- (BOOL) isIphone5{
     CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(screenSize.height > 480)
        return YES;
    return NO;
}

@end
