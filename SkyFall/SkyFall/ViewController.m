//
//  ViewController.m
//  SkyFall
//
//  Created by Chris Lesch on 6/11/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"
#import "WelcomeScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create, configure, and present the scene.
    WelcomeScene *welcome = [[WelcomeScene alloc] initWithSize:self.view.bounds.size];
    [skView presentScene:welcome];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
