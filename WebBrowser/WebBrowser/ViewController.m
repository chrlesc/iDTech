//
//  ViewController.m
//  WebBrowser
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Don't dispaly the tab bar menu at the start.
    [self.tabBar setHidden:YES];
    [self.DimView setBackgroundColor:[UIColor clearColor]];
    [self.DimView setAlpha:0.6];
    [self.DimView setUserInteractionEnabled:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *homepage = [userDefaults URLForKey:@"homepage"];
    if(homepage){
        [self.addressText setText:[homepage absoluteString]];
        [self pressedGo:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    //Just do this to deselect settings in the menu.
    [self.tabBar setSelectedItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedGo:(id)sender {
    NSString *urlString = self.addressText.text;
    NSURL *url;
    
    if([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"http:/"] || [urlString hasPrefix:@"http:"]) {
        url = [NSURL URLWithString:urlString];
    }else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.addressText.text]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)pressedForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)pressedBackward:(id)sender {
    [self.webView goBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.addressText setText:webView.request.URL.absoluteString];
}

- (IBAction)PullUpSettings:(id)sender {
    [self.tabBar setHidden:NO];
    [self.DimView setBackgroundColor:[UIColor blackColor]];
    [self.DimView setUserInteractionEnabled:YES];    
}

- (IBAction)DismissSettings:(id)sender {
    [self.tabBar setHidden:YES];
    [self.DimView setBackgroundColor:[UIColor clearColor]];
    [self.DimView setUserInteractionEnabled:NO];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{   
    SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
