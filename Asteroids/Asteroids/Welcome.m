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
    region = [[UIView alloc]initWithFrame:CGRectMake(wLabel.frame.origin.x, wLabel.frame.origin.y- wLabel.frame.size.height, wLabel.frame.size.width, wLabel.frame.size.height)];
    //Make the view invisible.
    [region setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:region];
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeView)];
    [region addGestureRecognizer:tapGesture];
    
}
- (void)changeView{
    MyScene *nextScene = [[MyScene alloc] initWithSize:self.size];
    [self.view presentScene:nextScene];
}
//Called right before this view resigns.
- (void)willMoveFromView:(SKView *)view{
    [region removeFromSuperview];
    [play removeFromSuperview];
    //Gets called implicity by garbage collector.
    //[region removeGestureRecognizer:tapGesture];
}
@end
