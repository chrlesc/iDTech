//
//  ViewController.h
//  Asteroids
//

//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController
-(void)initGame;
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
@end
