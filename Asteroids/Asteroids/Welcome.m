//
//  Welcome.m
//  Asteroids
//
//  Created by Chris Lesch on 6/19/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "Welcome.h"
#import "MyScene.h"

@implementation Welcome

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        wLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [wLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
        [wLabel setText:@"Welcome To Asteroids"];
        [wLabel setFontSize:24.0];
        [self addChild:wLabel];
        
        
    }
    return self;
}
//Called before we move to this view.
- (void)didMoveToView:(SKView *)view{
    //panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zo)]
   // tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView)];
   // [region addGestureRecognizer:tapGesture];
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [wLabel setScale:scrollView.zoomScale];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.view;
}
- (void)changeView{
    MyScene *nextScene = [[MyScene alloc] initWithSize:self.size];
    [self.view presentScene:nextScene];
}
//Called right before this view resigns.
- (void)willMoveFromView:(SKView *)view{
 //   [region removeFromSuperview];
  //  [play removeFromSuperview];
    //Gets called implicity by garbage collector.
    //[region removeGestureRecognizer:tapGesture];
}
@end
