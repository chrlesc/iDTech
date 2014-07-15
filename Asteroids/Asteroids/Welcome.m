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
        
        [self setAnchorPoint:(CGPoint){0,1}];
        
        _spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [_spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [_spriteToScroll setZPosition:0];
        [self addChild:_spriteToScroll];
        
        _spriteForScrollingGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [_spriteForScrollingGeometry setAnchorPoint:(CGPoint){0,0}];
        [_spriteForScrollingGeometry setPosition:(CGPoint){0, -size.height}];
        [_spriteToScroll addChild:_spriteForScrollingGeometry];
        
        _spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [_spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [_spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
        [_spriteForStaticGeometry setZPosition:2];
        [self addChild:_spriteForStaticGeometry];
        
        _spriteToHostHorizontalAndVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [_spriteToHostHorizontalAndVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [_spriteToHostHorizontalAndVerticalScrolling setPosition:(CGPoint){0, -size.height}];
        [_spriteToHostHorizontalAndVerticalScrolling setZPosition:1];
        [self addChild:_spriteToHostHorizontalAndVerticalScrolling];
        
        CGSize upAndDownSize = size;
        upAndDownSize.width = 30;
        _spriteForVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:upAndDownSize];
        [_spriteForVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [_spriteForVerticalScrolling setPosition:(CGPoint){0,30}];
        [_spriteToHostHorizontalAndVerticalScrolling addChild:_spriteForVerticalScrolling];
        
        CGSize leftToRightSize = size;
        leftToRightSize.height = 30;
        _spriteForHorizontalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:leftToRightSize];
        [_spriteForHorizontalScrolling setAnchorPoint:(CGPoint){0,0}];
        [_spriteForHorizontalScrolling setPosition:(CGPoint){10,0}];
        [_spriteToHostHorizontalAndVerticalScrolling addChild:_spriteForHorizontalScrolling];
        
        
        
    
        SKSpriteNode *blueTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
                                                                    size:(CGSize){.width = size.width*.25,
                                                                        .height = size.height*.25}];
        [blueTestSprite setName:@"blueTestSprite"];
        [blueTestSprite setAnchorPoint:(CGPoint){0,0}];
        [blueTestSprite setPosition:(CGPoint){.x = size.width * .25, .y = size.height *.65}];
        [_spriteForScrollingGeometry addChild:blueTestSprite];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        [label setText:@"Welcome"];
        [label setPosition:(CGPoint){200,200}];
        [_spriteForScrollingGeometry addChild:label];
        
        _contentSize = size;
        _contentOffset = (CGPoint){0,0};
        
    }
    return self;
}
 
- (void)changeView{
    MyScene *nextScene = [[MyScene alloc] initWithSize:self.size];
    [self.view presentScene:nextScene];
}

-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];
    
    CGPoint lowerLeft = (CGPoint){0, -size.height};
    
    [self.spriteForStaticGeometry setSize:size];
    [self.spriteForStaticGeometry setPosition:lowerLeft];
    
    [self.spriteToHostHorizontalAndVerticalScrolling setSize:size];
    [self.spriteToHostHorizontalAndVerticalScrolling setPosition:lowerLeft];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:(CGPoint){0, -contentSize.height}];
        [self updateConstrainedScrollerSize];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];
    
    CGPoint scrollingLowerLeft = [self.spriteForScrollingGeometry convertPoint:(CGPoint){0,0} toNode:self.spriteToHostHorizontalAndVerticalScrolling];
    
    CGPoint horizontalScrollingPosition = [self.spriteForHorizontalScrolling position];
    horizontalScrollingPosition.y = scrollingLowerLeft.y;
    [self.spriteForHorizontalScrolling setPosition:horizontalScrollingPosition];
    
    CGPoint verticalScrollingPosition = [self.spriteForVerticalScrolling position];
    verticalScrollingPosition.x = scrollingLowerLeft.x;
    [self.spriteForVerticalScrolling setPosition:verticalScrollingPosition];
}

-(void)setContentScale:(CGFloat)scale
{
    [self.spriteToScroll setScale:scale];
    [self updateConstrainedScrollerSize];
}

-(void)updateConstrainedScrollerSize
{
    
    CGSize contentSize = [self contentSize];
    CGSize verticalSpriteSize = [self.spriteForVerticalScrolling size];
    verticalSpriteSize.height = contentSize.height;
    [self.spriteForVerticalScrolling setSize:verticalSpriteSize];
    
    CGSize horizontalSpriteSize = [self.spriteForHorizontalScrolling size];
    horizontalSpriteSize.width = contentSize.width;
    [self.spriteForHorizontalScrolling setSize:horizontalSpriteSize];
    
    CGFloat xScale = [self.spriteToScroll xScale];
    CGFloat yScale = [self.spriteToScroll yScale];
    [self.spriteForVerticalScrolling setYScale:yScale];
    [self.spriteForVerticalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setYScale:yScale];
    CGFloat xScaleReciprocal = 1.0/xScale;
    CGFloat yScaleReciprocal = 1/yScale;
    for (SKNode *node in [self.spriteForVerticalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }
    for (SKNode *node in [self.spriteForHorizontalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }
    
    [self setContentOffset:self.contentOffset];
}

@end
