//
//  ArcheryScene.m
//  SkyFall
//
//  Created by Chris Lesch on 6/11/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ArcheryScene.h"
#import "WelcomeScene.h"

@implementation ArcheryScene

static const uint32_t arrowCategory = 0x1 << 0;
static const uint32_t ballCategory = 0x1 << 1;

- (void)didMoveToView:(SKView *)view
{
    if (!self.sceneCreated)
    {
        self.score = 0;
        self.ballCount = 40;
        self.physicsWorld.gravity = CGVectorMake(0, -3.0);
        self.physicsWorld.contactDelegate = self;
        
        [self initArcheryScene];
        self.sceneCreated = YES;
    }
}

- (void) initArcheryScene
{
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    SKSpriteNode *archerNode = [self createArcherNode];
    
    archerNode.position =
    CGPointMake(CGRectGetMinX(self.frame)+55,
                CGRectGetMidY(self.frame));
    
    [self addChild:archerNode];
    
    NSMutableArray *archerFrames = [NSMutableArray array];
    
    SKTextureAtlas *archerAtlas =
    [SKTextureAtlas atlasNamed:@"archer"];
    
    for (int i = 1; i < archerAtlas.textureNames.count+1; ++i)
    {
        NSString *texture =
        [NSString stringWithFormat:@"archer%03d", i];
        [archerFrames addObject:[archerAtlas textureNamed:texture]];
    }
    
    self.archerAnimation = archerFrames;
    
    SKAction *releaseBalls = [SKAction sequence:@[
                                                  [SKAction performSelector:@selector(createBallNode) onTarget:self],
                                                  [SKAction waitForDuration:1]
                                                  ]];
    
    [self runAction: [SKAction repeatAction:releaseBalls count:self.ballCount] completion:^{
        [SKAction waitForDuration:3.0];
        [self gameOver];
    }];
}

- (SKSpriteNode *)createArcherNode
{
    SKSpriteNode *archerNode =  
    [[SKSpriteNode alloc] initWithImageNamed:@"archer001.png"];
    
    archerNode.name = @"archerNode";
    return archerNode;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    SKNode *archerNode = [self childNodeWithName:@"archerNode"];
    
    if (archerNode != nil)
    {
        SKAction *animate =
        [SKAction animateWithTextures:self.archerAnimation
                         timePerFrame: 0.05];
        
        SKAction *shootArrow = [SKAction runBlock:^{
            
            SKNode *arrowNode = [self createArrowNode];
            
            [self addChild:arrowNode];
            [arrowNode.physicsBody applyImpulse:CGVectorMake(35.0, 0)];
        }];
        
        SKAction *sequence =
        [SKAction sequence:@[animate, shootArrow]];
        
        [archerNode runAction:sequence];
    }
}

- (SKSpriteNode *) createArrowNode
{
    SKSpriteNode *arrow =
    [[SKSpriteNode alloc] initWithImageNamed:@"ArrowTexture.png"];
    
    arrow.position = CGPointMake(CGRectGetMinX(self.frame)+100,
                                 CGRectGetMidY(self.frame));
    
    arrow.name = @"arrowNode";
    
    arrow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:arrow.frame.size];
    arrow.physicsBody.usesPreciseCollisionDetection = YES;
    arrow.physicsBody.categoryBitMask = arrowCategory;
    arrow.physicsBody.collisionBitMask = arrowCategory | ballCategory;
    arrow.physicsBody.contactTestBitMask = arrowCategory | ballCategory;
    
    return arrow;
}

- (void) createBallNode
{
    SKSpriteNode *ball = [[SKSpriteNode alloc]
                          initWithImageNamed:@"BallTexture.png"];
    int ballX = (arc4random() % (int)(self.size.width-200)) + 200;
    ball.position = CGPointMake(ballX, self.size.height-50);
    
    ball.name = @"ballNode";
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(ball.size.width/2)-7];
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    ball.physicsBody.categoryBitMask = ballCategory;
    
    [self addChild:ball];
}

- (SKLabelNode *) createScoreNode
{
    SKLabelNode *scoreNode =
    [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    scoreNode.name = @"scoreNode";
    
    NSString *newScore =
    [NSString stringWithFormat:@"Score: %i", self.score];
    
    scoreNode.text = newScore;
    scoreNode.fontSize = 60;
    scoreNode.fontColor = [SKColor redColor];
    
    scoreNode.position =
    CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    return scoreNode;
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    if ((contact.bodyA.categoryBitMask == arrowCategory)
        && (contact.bodyB.categoryBitMask == ballCategory))
    {
        CGPoint contactPoint = contact.contactPoint;
        
        float contact_x = contactPoint.x;
        float contact_y = contactPoint.y;
        float target_y = secondNode.position.y;
        
        float margin = secondNode.frame.size.height/2 - 20;
        
        if ((contact_y > (target_y - margin)) &&
            (contact_y < (target_y + margin)))
        {
            SKPhysicsJointFixed *joint =
            [SKPhysicsJointFixed jointWithBodyA:contact.bodyA
                                          bodyB:contact.bodyB
                                         anchor:CGPointMake(contact_x, contact_y)];
            
            [self.physicsWorld addJoint:joint];
            
            SKTexture *texture =
            [SKTexture textureWithImageNamed:@"ArrowHitTexture"];
            firstNode.texture = texture;
            self.score++;
        }
    }
}

- (void) gameOver
{
    SKLabelNode *scoreNode = [self createScoreNode];
    
    [self addChild:scoreNode];
    
    SKAction *fadeOut = [SKAction sequence:@[[SKAction
                                              waitForDuration:3.0],
                                             [SKAction fadeOutWithDuration:3.0]]];
    
    SKAction *welcomeReturn = [SKAction runBlock:^{
        
        SKTransition *transition =
        [SKTransition revealWithDirection:SKTransitionDirectionDown
                                 duration:1.0];
        
        WelcomeScene *welcomeScene =
        [[WelcomeScene alloc] initWithSize:self.size];
        
        [self.scene.view presentScene: welcomeScene
                           transition:transition];
    }];
    
    SKAction *sequence = [SKAction sequence:@[fadeOut, welcomeReturn]];
    
    [self runAction:sequence];
}
@end
