//
//  Welcome.h
//  Asteroids
//
//  Created by Chris Lesch on 6/19/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Welcome : SKScene {
    UITapGestureRecognizer *tapGesture;
    UIPanGestureRecognizer *panGesture;
    UIButton *play;
    SKLabelNode *wLabel;
}
@property (nonatomic, weak) SKSpriteNode *spriteToScroll;
@property (nonatomic, weak) SKSpriteNode *spriteForScrollingGeometry;
@property (nonatomic, weak) SKSpriteNode *spriteForStaticGeometry;
@property (nonatomic, weak) SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForHorizontalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForVerticalScrolling;
@property (nonatomic) CGSize contentSize;
@property(nonatomic) CGPoint contentOffset;
-(void)setContentSize:(CGSize)contentSize;
-(void)setContentScale:(CGFloat)scale;
-(void)setContentOffset:(CGPoint)contentOffset;


@end
