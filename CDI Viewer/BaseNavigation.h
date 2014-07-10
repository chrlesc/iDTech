//
//  BaseNavigation.h
//  CDI Viewer
//
//  Created by Chris Lesch on 1/14/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "LoginView.h"
#import "TableState.h"


@interface BaseNavigation : UIViewController<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    IBOutlet NSLayoutConstraint *topConstraint;
    IBOutlet NSLayoutConstraint *botConstraint;
    int downDistance;
}
@property(nonatomic,retain)IBOutlet UIButton *loginButton;
@property(atomic,retain)IBOutlet UITableView *table;
@property(nonatomic,retain)IBOutlet UITextField *documentID;
@property(nonatomic,retain)IBOutlet UILabel *hello;
@property(atomic,retain)IBOutlet UILabel *response;
@property(nonatomic, retain)NSMutableArray *states;
@property(nonatomic, retain)NSMutableArray *statesTemp;

- (IBAction)SettingsSelected;
- (IBAction)LoginSelected;

- (void)loadDocuments;

- (void)removeResponseMessage;
- (IBAction)downloadDocument;
- (void) downloadDocument:(NSString *)docID;

- (TableState *) addRow:(NSString *)fileName docID:(NSString *)docID IDLabel:(NSString *)IDLabel;
- (TableState *) addRow:(TableState *) aState;
- (void) removeRow:(TableState *)aState request_hash:(NSNumber*)request_hash;

- (void) keyboardDidShow:(NSNotification*)notification;
- (void)keyboardDidHide:(NSNotification*)notification;
- (void) animateTextField:(NSNotification*)notification up:(BOOL)up;

@end
