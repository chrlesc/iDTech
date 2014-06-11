//
//  MyScene.m
//  Asteroids
//
//  Created by Chris Lesch on 6/9/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        //Create the DPad
        [self createDPad];
        
        //Set up the player spaceship sprite.
        self.playerSprite = [Spaceship spriteNodeWithImageNamed:@"Spaceship"];
        [self.playerSprite setScale:0.15];
        [self.playerSprite setMVelocity:0];
        [self.playerSprite setRVelocity:0];
        [self.playerSprite setPosition: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self addChild:self.playerSprite];
        
        //Instantiate the asteroid array.
        self.asteroids = [[NSMutableArray alloc]init];
        
        //Add the timer to the run loop.
        timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(spawnAsteroid) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (CGRectContainsPoint(self.upButtonSprite.frame, location)) {
            [self.playerSprite setMVelocity:1];
            [self playSound:@"Thrusters"];
        }
        if (CGRectContainsPoint(self.downButtonSprite.frame, location)) {
            [self.playerSprite setMVelocity:-1];
            [self playSound:@"Thrusters"];
        }
        if (CGRectContainsPoint(self.leftButtonSprite.frame, location)) {
            [self.playerSprite setRVelocity:1];
        }
        if (CGRectContainsPoint(self.rightButtonSprite.frame, location)) {
            [self.playerSprite setRVelocity:-1];
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.playerSprite setMVelocity:0];
    [self.playerSprite setRVelocity:0];
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (CGRectContainsPoint(self.upButtonSprite.frame, location)) {
            [self.playerSprite setMVelocity:1];
        }
        else if (CGRectContainsPoint(self.downButtonSprite.frame, location)) {
            [self.playerSprite setMVelocity:-1];
        }
        else if (CGRectContainsPoint(self.leftButtonSprite.frame, location)) {
            [self.playerSprite setRVelocity:1];
        }
        else if (CGRectContainsPoint(self.rightButtonSprite.frame, location)) {
            [self.playerSprite setRVelocity:-1];
        }
    }
}
//Note:  The way they wrote the code, if you release two fingers at same time velocities will never get set to zero!  So let's figure out how many touches are left on the screen a more robust way.
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSSet *allTouches = [event allTouches];
    if (allTouches.count - touches.count == 0) {
        [self.playerSprite setMVelocity:0];
        [self.playerSprite setRVelocity:0];
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (CGRectContainsPoint(self.upButtonSprite.frame, location) ||
            CGRectContainsPoint(self.downButtonSprite.frame, location)){
            [self.playerSprite setMVelocity:0];
        }
        if (CGRectContainsPoint(self.leftButtonSprite.frame, location) ||
            CGRectContainsPoint(self.rightButtonSprite.frame, location)){
            [self.playerSprite setRVelocity:0];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    //Determine the amount to spin.
    [self.playerSprite setZRotation:self.playerSprite.zRotation+M_PI*(2.0/180.0)*self.playerSprite.RVelocity];
    //Calculate the delta_x and delta_y based on angle of ship.
    float delta_x = sin(-self.playerSprite.zRotation)*self.playerSprite.MVelocity;
    float delta_y = cos(-self.playerSprite.zRotation)*self.playerSprite.MVelocity;
    
    [self.playerSprite setPosition:CGPointMake(self.playerSprite.position.x + delta_x,self.playerSprite.position.y + delta_y)];
    
    //Update each of the asteroids positions.
    for(int i = 0; i < self.asteroids.count; i++){
        Asteroid *asteroid = [self.asteroids objectAtIndex:i];
        [asteroid setPosition:CGPointMake(asteroid.position.x,
                                          asteroid.position.y + asteroid.YVelocity)];
        //Probably a good idea to remove the asteroid once off screen too!
        if(asteroid.position.y < -10){
            [asteroid removeFromParent];
            [self.asteroids removeObjectAtIndex:i];
        }
    }
    
    //Check for collisions.
    [self checkCollisions];
}

-(void)createDPad {
    //Connect the images to the sprites.
    self.upButtonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow"];
    self.downButtonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow"];
    self.leftButtonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow"];
    self.rightButtonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow"];
    
    //Position the arrows in the bottom left corner.  Note where (0,0) is.
    [self.upButtonSprite setPosition:CGPointMake(41,75)];
    [self.downButtonSprite setPosition:CGPointMake(41,25)];
    [self.leftButtonSprite setPosition:CGPointMake(16,50)];
    [self.rightButtonSprite setPosition:CGPointMake(65,50)];

    
    //Rotate the arrows to point the right direction.
    [self.downButtonSprite setZRotation:M_PI];
    [self.leftButtonSprite setZRotation:M_PI_2];
    [self.rightButtonSprite setZRotation:-M_PI_2];
    
    [self addChild:self.upButtonSprite];
    [self addChild:self.downButtonSprite];
    [self addChild:self.leftButtonSprite];
    [self addChild:self.rightButtonSprite];
}

-(void)spawnAsteroid {
    Asteroid *asteroid = [Asteroid spriteNodeWithImageNamed:@"Asteroid"];
    [asteroid setScale:0.25];
    
    //Pick a random x-position to start at, and determine the height to start at.
    float randomXStartingPosition = (arc4random() % 280) + 50;
    [asteroid setPosition:CGPointMake(randomXStartingPosition, [UIScreen mainScreen].bounds.size.height+asteroid.size.height)];
    
    //Pick the velocity of the asteroid.
    float randomY = -((arc4random() % 20)/10.0f);
    [asteroid setYVelocity:randomY];
    
    [self.asteroids addObject:asteroid];
    [self addChild:asteroid];
}

-(void)checkCollisions {
    for (Asteroid *asteroid in self.asteroids) {
        if (CGRectIntersectsRect(asteroid.frame, self.playerSprite.frame)) {
            [self playSound:@"Explosion"];
            
            [self removeAllChildren];
            [timer invalidate];
            
            SKLabelNode *youLoseLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            [youLoseLabel setText:@"You lose :("];
            [youLoseLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),
                                                  CGRectGetMidY(self.frame))];
            [self addChild:youLoseLabel];
        }
    }
}

- (void)playSound:(NSString *)fileName{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath],
                                     &soundID);
    AudioServicesPlaySystemSound (soundID);
}

@end
