//
//  MyScene.h
//  Asteroids
//

//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Spaceship.h"
#import "Asteroid.h"
#import <AudioToolbox/AudioToolbox.h>

typedef enum{
    left,
    right,
    up,
    down,
    none
}Direction;

@interface MyScene : SKScene <SKPhysicsContactDelegate>{
    NSTimer *timer;
    uint32_t rocketCategory;
    uint32_t asteroidCategory;
    uint32_t wallCategory;
}
@property (nonatomic, strong) SKSpriteNode *upButtonSprite;
@property (nonatomic, strong) SKSpriteNode *downButtonSprite;
@property (nonatomic, strong) SKSpriteNode *leftButtonSprite;
@property (nonatomic, strong) SKSpriteNode *rightButtonSprite;
@property (nonatomic, strong) Spaceship *playerSprite;
@property (nonatomic, strong) NSMutableArray *asteroids;
@property (atomic, assign) BOOL gameOver;
@property (atomic, assign) Direction currentDirection;
- (void)createDPad;
- (void)spawnAsteroid;
- (void)playSound:(NSString *)fileName type:(NSString*)fileType;
@end
