//
//  SettingsViewController.m
//  WebBrowser
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *homepage = [userDefaults URLForKey:@"homepage"];
    if(homepage){
        [self.HomepageURL setText:[homepage absoluteString]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveSettings:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setURL:[NSURL URLWithString:self.HomepageURL.text] forKey:@"homepage"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
