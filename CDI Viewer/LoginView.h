//
//  LoginView.h
//  CDI Viewer
//
//  Created by Chris Lesch on 1/3/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "tableCell.h"

@interface LoginView : UIViewController <UITextFieldDelegate>{
    IBOutlet NSLayoutConstraint *centerY;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UILabel *LoginResult;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *backButton;
    NSString *action;
    NSString *myNewRequestString;
    int downDistance;
}
- (IBAction)enterCredentials;
- (IBAction)back;
- (void)displayCookies:(NSURL *)displayURL;
- (void)deleteCookies;
- (BOOL)currentlyLoggedIn;
- (void) keyboardDidShow:(NSNotification*)notification;
- (void)keyboardDidHide:(NSNotification*)notification;
- (void) animateTextField:(NSNotification*)notification up:(BOOL)up;
- (void) startingDocsCheck;
@end
