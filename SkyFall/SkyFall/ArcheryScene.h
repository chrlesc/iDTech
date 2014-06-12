//
//  ArcheryScene.h
//  SkyFall
//
//  Created by Chris Lesch on 6/11/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ArcheryScene : SKScene <SKPhysicsContactDelegate>
@property (nonatomic, assign) BOOL sceneCreated;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int ballCount;
@property NSArray *archerAnimation;
@end
