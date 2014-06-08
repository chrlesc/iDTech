//
//  TabBarControl.m
//  TabBarController
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "TabBarControl.h"

@interface TabBarControl ()

@end

@implementation TabBarControl

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
    UITabBar *tabBar = [self tabBar];
    UITabBarItem *firstItem = [[tabBar items] objectAtIndex:0];
    UIEdgeInsets firstEdge = UIEdgeInsetsMake(5, 0, 0, 0);
    [firstItem setImageInsets:firstEdge];
    [firstItem setImage:[[UIImage imageNamed:@"Tree"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [firstItem setSelectedImage:[[UIImage imageNamed:@"SelectedTree"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
