//
//  Welcome.h
//  Asteroids
//
//  Created by Chris Lesch on 6/19/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Welcome : SKScene{
    UITapGestureRecognizer *tapGesture;
    UIButton *play;
    UIView *region;
    SKLabelNode *wLabel;
}

@end