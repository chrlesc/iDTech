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

@interface MyScene : SKScene{
    NSTimer *timer;
}
@property (nonatomic, strong) SKSpriteNode *upButtonSprite;
@property (nonatomic, strong) SKSpriteNode *downButtonSprite;
@property (nonatomic, strong) SKSpriteNode *leftButtonSprite;
@property (nonatomic, strong) SKSpriteNode *rightButtonSprite;
@property (nonatomic, strong) Spaceship *playerSprite;
@property (nonatomic, strong) NSMutableArray *asteroids;
@property (atomic, assign) BOOL gameOver;
- (void)createDPad;
- (void)checkCollisions;
- (void)spawnAsteroid;
- (void)playSound:(NSString *)fileName type:(NSString*)fileType;
@end
