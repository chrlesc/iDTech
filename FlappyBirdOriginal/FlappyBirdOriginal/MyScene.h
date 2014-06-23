//
//  MyScene.h
//  FlappyBirdOriginal
//

//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    NSTimeInterval _dt;
    float bottomScrollerHeight;
}
@property (nonatomic) SKSpriteNode* backgroundImageNode;
@property (nonatomic) SKSpriteNode* flappyBird;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end
