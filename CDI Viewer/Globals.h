//
//  Globals.h
//  CDI Viewer
//
//  Created by Chris Lesch on 1/15/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNavigation.h"
#import "LoginView.h"
#import "Settings.h"
#import "DocumentViewController.h"

@interface Globals : NSObject{
    
}
@property(nonatomic, retain)LoginView *login;
@property(nonatomic, retain)BaseNavigation *base;
@property(nonatomic, retain)Settings *settings;
@property(nonatomic, retain)DocumentViewController *documentViewController;
@property(atomic, retain)NSURLSession *session;
@property(nonatomic, retain)NSMutableArray *startingDocs;
@property(atomic, retain)NSMutableDictionary *currently_downloading;
+ (Globals *)getInstance;
- (NSString *)documentsBasePath;
- (BOOL)isIphone5;
@end
