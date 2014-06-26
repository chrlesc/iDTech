//
//  ViewController.h
//  Asteroids
//

//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Welcome.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>
@property(nonatomic, weak) Welcome *scene;
@property(nonatomic, weak) UIView *clearContentView;
-(void)initGame;
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
@end
