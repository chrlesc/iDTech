//
//  GameOver.m
//  Asteroids
//
//  Created by Chris Lesch on 6/13/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver
-(void) didMoveToView:(SKView *)view{
    if(~self.sceneCreated){
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.scaleMode = SKSceneScaleModeAspectFill;
        
        SKLabelNode *youLoseLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [youLoseLabel setText:@"You lose :("];
        [youLoseLabel setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self addChild:youLoseLabel];
        self.sceneCreated = YES;
    }
}
@end
