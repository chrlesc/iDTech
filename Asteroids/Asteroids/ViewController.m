//
//  ViewController.m
//  Asteroids
//
//  Created by Chris Lesch on 6/9/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "Welcome.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGame];
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
//Check for a shake gesture, and if we get one restart the game.
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self initGame];
    }
}

-(void)initGame{
    region = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [region setUserInteractionEnabled:YES];
    [region setBackgroundColor:[UIColor clearColor]];
    //region = [[UIView alloc]initWithFrame:CGRectMake(wLabel.frame.origin.x, wLabel.frame.origin.y- wLabel.frame.size.height, wLabel.frame.size.width, wLabel.frame.size.height)];
    //Make the view invisible.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    [skView addSubview:region];
    
    Welcome *scene = [Welcome sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [region setDelegate:scene];
    [skView presentScene:scene];
}

@end
