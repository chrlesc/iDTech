//
//  ViewController.m
//  Asteroids
//
//  Created by Chris Lesch on 6/9/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"


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
    //Instantiate the SKView.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    //Instantiate the screen.
    Welcome *scene = [Welcome sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    _scene = scene;
    
    CGSize contentSize = skView.frame.size;
    contentSize.height *= 1.5;
    contentSize.width *= 1.5;
    [scene setContentSize:contentSize];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:skView.frame];
    [scrollView setContentSize:contentSize];
    
    scrollView.delegate = self;
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:3.0];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    UIView *clearContentView = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = contentSize}];
    [clearContentView setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:clearContentView];
    [skView addSubview: scrollView];
    
    _clearContentView = clearContentView;
    
}
-(void)adjustContent:(UIScrollView *)scrollView
{
    CGFloat zoomScale = [scrollView zoomScale];
    [self.scene setContentScale:zoomScale];
    CGPoint contentOffset = [scrollView contentOffset];
    [self.scene setContentOffset:contentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustContent:scrollView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.clearContentView;
}

-(void)scrollViewDidTransform:(UIScrollView *)scrollView
{
    [self adjustContent:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
{
    [self adjustContent:scrollView];
}

@end
