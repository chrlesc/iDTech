//
//  MyScene.m
//  FlappyBirdOriginal
//
//  Created by Chris Lesch on 6/22/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

#define TIME 1.5
#define NUM_BACKGROUND 3
#define MINIMUM_PILLER_HEIGHT 50.0f
#define GAP_BETWEEN_TOP_AND_BOTTOM_PILLER 200.0f

static const uint32_t pillarCategory            =  0x1 << 0;
static const uint32_t flappyBirdCategory        =  0x1 << 1;

static const float BG_VELOCITY = (TIME * 60);

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
- (void)pillar:(SKSpriteNode *)pillar didCollideWithBird:(SKSpriteNode *)bird
{
    //Remove pillar if collision is detected and continue to play
    [pillar removeFromParent];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _flappyBird.physicsBody.velocity = CGVectorMake(0, 250);
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & pillarCategory) != 0 &&
        (secondBody.categoryBitMask & flappyBirdCategory) != 0)
    {
        [self pillar:(SKSpriteNode *) firstBody.node didCollideWithBird:(SKSpriteNode *) secondBody.node];
    }
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //Initialize the static background
        [self initializeBackGround:size];
        
        //Initialize moving background
        [self initalizingScrollingBackground];
        
        //Initialize Bird
        [self initializeBird];
        
        //To have Gravity effect on Bird so that bird flys down when not tapped
        self.physicsWorld.gravity = CGVectorMake(0, -4.0);
        
        //To detect collision detection
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        

    }
    return self;
}

- (void) initializeBackGround:(CGSize) sceneSize
{
    self.backgroundImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"Space"];
    self.backgroundImageNode.size = sceneSize;
    self.backgroundImageNode.position = CGPointMake(self.backgroundImageNode.size.width/2, self.frame.size.height/2);
    [self addChild:self.backgroundImageNode];
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < NUM_BACKGROUND; i++)
    {
       // int type = arc4random() % 3+1;
        int type = 2;
        NSString *platformName = [NSString stringWithFormat:@"Platform%d",type];
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:platformName];
        bottomScrollerHeight = bg.size.height;
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        
        [self addChild:bg];
    }
}
- (void)moveBottomScroller
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*3,
                                       bg.position.y);
         }
         
        [bg removeFromParent];
         [self addChild:bg];        //Ordering is not possible. so this is a hack
     }];
}

- (void)initializeBird
{
    self.flappyBird = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    self.flappyBird.position = CGPointMake(self.backgroundImageNode.size.width * 0.3f, self.frame.size.height * 0.6f);
    [self.flappyBird setScale:0.50f];
    [self.flappyBird setZRotation:-M_PI/2.0];
    
    /*
     * Create a physics and specify its geometrical shape so that collision algorithm
     * can work more prominently
     */
    _flappyBird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_flappyBird.size];
    _flappyBird.physicsBody.dynamic = YES;
    
    //Tell SpriteKit to detect very precise collision detection
    _flappyBird.physicsBody.usesPreciseCollisionDetection = YES;
    
    //Category to which this object belongs to
    _flappyBird.physicsBody.categoryBitMask = flappyBirdCategory;
    
    //To notify intersection with objects
    _flappyBird.physicsBody.contactTestBitMask = pillarCategory;
    
    //To detect collision with category of objects
    _flappyBird.physicsBody.collisionBitMask = 0;
    
    [self addChild:self.flappyBird];
}

- (SKSpriteNode*) createPillerWithUpwardDirection:(BOOL) isUpwards
{
    NSString* pillerImageName = nil;
    SKSpriteNode *piller = [SKSpriteNode spriteNodeWithImageNamed:@"UpwardTower"];
    if (!isUpwards)
    {
        [piller setZRotation:M_PI];
    }
    
    [piller setYScale:30];
    /*
     * Create a physics and specify its geometrical shape so that collision algorithm
     * can work more prominently
     */
    piller.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:piller.size];
    piller.physicsBody.dynamic = YES;
    
    //Category to which this object belongs to
    piller.physicsBody.categoryBitMask = pillarCategory;
    
    //To notify intersection with objects
    piller.physicsBody.contactTestBitMask = flappyBirdCategory;
    
    //To detect collision with category of objects. Default all categories
    piller.physicsBody.collisionBitMask = 0;
    
    /*
     * Has to be explicitely mentioned. If not mentioned, pillar starts moving down becuase of gravity.
     */
    piller.physicsBody.affectedByGravity = NO;
    
    [self addChild:piller];
    
    return piller;
}

- (void)addAPiller
{
    //Create Upward directed pillar
    SKSpriteNode* upwardPiller = [self createPillerWithUpwardDirection:YES];
    
    int minY = MINIMUM_PILLER_HEIGHT;
    int maxY = self.frame.size.height - GAP_BETWEEN_TOP_AND_BOTTOM_PILLER - MINIMUM_PILLER_HEIGHT;
    int rangeY = maxY - minY;
    
    float upwardPillerY = ((arc4random() % rangeY) + minY) - upwardPiller.size.height;
    upwardPillerY += upwardPiller.size.height * 0.5f;
    
    /*Set position of pillar start position outside the screen so that we can be
     sure that image is created before it comes inside screen visibility area
     */
    upwardPiller.position = CGPointMake(self.frame.size.width + upwardPiller.size.width/2, upwardPillerY);
    
    //Create Downward directed pillar
    SKSpriteNode* downwardPiller = [self createPillerWithUpwardDirection:NO];
    float downloadPillerY = upwardPillerY + upwardPiller.size.height + GAP_BETWEEN_TOP_AND_BOTTOM_PILLER;
    downwardPiller.position = CGPointMake(upwardPiller.position.x, downloadPillerY);
    
    /*
     * Create Upward Piller actions.
     * First action has to be the movement of pillar. Right to left.
     * Once first action is complete, remove that node from Scene
     */
    SKAction * upwardPillerActionMove = [SKAction moveTo:CGPointMake(-upwardPiller.size.width/2, upwardPillerY) duration:(TIME * 2)];
    SKAction * upwardPillerActionMoveDone = [SKAction removeFromParent];
    [upwardPiller runAction:[SKAction sequence:@[upwardPillerActionMove, upwardPillerActionMoveDone]]];
    
    // Create Downward Piller actions
    SKAction * downwardPillerActionMove = [SKAction moveTo:CGPointMake(-downwardPiller.size.width/2, downloadPillerY) duration:(TIME * 2)];
    SKAction * downwardPillerActionMoveDone = [SKAction removeFromParent];
    [downwardPiller runAction:[SKAction sequence:@[downwardPillerActionMove, downwardPillerActionMoveDone]]];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > TIME)
    {
        self.lastSpawnTimeInterval = 0;
        [self addAPiller];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.lastUpdateTimeInterval)
    {
        _dt = currentTime - _lastUpdateTimeInterval;
    }
    else
    {
        _dt = 0;
    }
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > TIME)
    {
        timeSinceLast = 1.0 / (TIME * 60.0);
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    [self moveBottomScroller];
}


@end
