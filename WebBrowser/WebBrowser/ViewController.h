//
//  ViewController.h
//  WebBrowser
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface ViewController : UIViewController <UIWebViewDelegate,UITabBarDelegate>
@property (strong, nonatomic) IBOutlet UITextField *addressText;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITabBarItem *Settings;
@property (strong, nonatomic) IBOutlet UIView *pullUpMenuView;
@property (strong, nonatomic) IBOutlet UIView *DimView;
- (IBAction)pressedGo:(id)sender;
- (IBAction)pressedForward:(id)sender;
- (IBAction)pressedBackward:(id)sender;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (IBAction)PullUpSettings:(id)sender;
- (IBAction)DismissSettings:(id)sender;

@end
