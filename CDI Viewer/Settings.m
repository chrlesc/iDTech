//
//  Settings.m
//  CDI Viewer
//
//  Created by Chris Lesch on 2/5/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set the switch to the currently saved default value.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [_wifi_only setOn:[userDefaults boolForKey:@"wifi_only"]];
    prev_wifi_only = _wifi_only.on;
}

/*Return to the view that brought you to this LoginView.
* */
- (IBAction)back{
    [self.navigationController popViewControllerAnimated:YES];
}
/*Update and store the desired status of wifi_only download mode*
* */
- (IBAction)wifi_update{
    if(prev_wifi_only != _wifi_only.on){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:_wifi_only.on forKey:@"wifi_only"];
        [userDefaults synchronize];
    }
    prev_wifi_only = _wifi_only.on;
}
@end
