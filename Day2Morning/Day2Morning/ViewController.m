//
//  ViewController.m
//  Day2Morning
//
//  Created by Chris Lesch on 6/16/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//Add an image to your app using ONLY code.
    playerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rock"]];
    [playerImage setFrame:CGRectMake(100,100,150,120)];
    [playerImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:playerImage];
    
    //Now leaving gameplan, here's one more example of the idea we are going for here.
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler)];
    //Set which direction this swipe is looking for.
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //Add the swipe recgonizer to the IMAGE VIEW.
    [playerImage addGestureRecognizer:swipeRight];
    //Make the image UserInteractionEnabled
    [playerImage setUserInteractionEnabled:YES];
}

//Function registered to be called when swipeRight gesture fires its action!
- (void)swipeRightHandler{
    //This line below starts an animation.
    [UIView beginAnimations:@"MyAnimation" context:nil];
    [UIView setAnimationDuration:2.0];
    //Code to be animated goes here.
    [playerImage setAlpha:0.0];
   // [playerImage setImage:[UIImage imageNamed:@"Paper"]];
   // [playerImage setAlpha:1.0];//--->  For a ticket, lets hear from someone what uncommenting this will do.
    [UIView commitAnimations];
    //Code line above ends the animation, any changes from the beginning state to the end state will then be animated.
   
    //Fade out, Fade in.  Block notation.
  /*  [UIView animateWithDuration:1.0 animations:^(void){
        [playerImage setAlpha:0.0];
    }
    completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 animations:^(void){
            [playerImage setImage:[UIImage imageNamed:@"Paper"]];
            [playerImage setAlpha:1.0];
        }];
    }];*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
