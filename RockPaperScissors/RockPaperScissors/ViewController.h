//
//  ViewController.h
//  RockPaperScissors
//
//  Created by Chris Lesch on 6/3/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    int count;
    int countdown;
    NSArray *imageNames;
    UISwipeGestureRecognizer *swipeRight;
    UISwipeGestureRecognizer *swipeLeft;
    UIImageView *computerView;
    IBOutlet UILabel *computerLabel;
    IBOutlet UIImageView *player1ImageView;
    NSTimer *countdownTimer;
    IBOutlet UIButton *startButton;
}
- (IBAction)startPressed:(id)sender;
@end
