//
//  ViewController.m
//  RockPaperScissors
//
//  Created by Chris Lesch on 6/3/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Here we add an image using code instead of storyboard, it's really personal preference as to which method you use.
    computerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Paper"]];
    [computerView setFrame:player1ImageView.frame];
    [computerView setFrame:CGRectMake(player1ImageView.frame.origin.x,computerLabel.frame.origin.y + computerLabel.frame.size.height,player1ImageView.frame.size.width,player1ImageView.frame.size.height)];
    [self.view addSubview:computerView];
    [computerView setHidden:YES];
    
    //Here we will use code to add gesture recognizers for two different swipes.
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [player1ImageView addGestureRecognizer:swipeRight];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [player1ImageView addGestureRecognizer:swipeLeft];
    
    //Let's make an array to store the image file names.
    imageNames = [[NSArray alloc] initWithObjects:@"Rock",@"Paper",@"Scissors",nil];
    
    //Don't forget to initialize our counter variables.
    count = 0;
    countdown = 1;
}
//Registered handler to change the player image on a swipe left.
- (void)swipeLeftHandler
{
    count = count - 1;
    if(count < 0){
        count = [imageNames count] - 1;
    }
    [player1ImageView setImage:[UIImage imageNamed:[imageNames objectAtIndex:count]]];
}
//Registered handler to change the player image on a swipe right.
- (void)swipeRightHandler
{
    count = count + 1;
    if(count >= [imageNames count]){
        count = 0;
    }
    [player1ImageView setImage:[UIImage imageNamed:[imageNames objectAtIndex:count]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-------------------------------------------------------
 There are two primary ways to schedule an event to occur at some point in the future.
 1.  Using some combination of NSTimer/NSDate to schedule an event to occur at a particular time, this will run on the main
 program thread so be sure not have it be blocking UI.
 2.  Using Grand Central Dispatch(GCD) to start an event on a seperate thread at a later point in time.
 */
- (IBAction)startPressed:(id)sender {
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

//Update the button label for the countdown, and control the game.
- (void)updateTimer
{
    if(countdown == 1){
        [startButton setTitle:@"ONE" forState:UIControlStateNormal];
        //Disable the start button once the countdown begins.
        [startButton setEnabled:NO];
    }else if(countdown == 2){
        [startButton setTitle:@"TWO" forState:UIControlStateNormal];
    }else if(countdown == 3){
        [startButton setTitle:@"THREE" forState:UIControlStateNormal];
    }else{
        countdown = 0;
        [startButton setTitle:@"SHOOT" forState:UIControlStateNormal];
        //Be sure to invalidate the countdown timer here, or it will keep re-calling update every second.
        [countdownTimer invalidate];
        
        //Let's use GCD to delay our image display until after shoot.
        dispatch_time_t shootTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(shootTime,dispatch_get_main_queue(),^(void){
            int compChoice = arc4random() % 3;
            [computerView setImage:[UIImage imageNamed:[imageNames objectAtIndex:compChoice]]];
            [computerView setHidden:NO];
        });

        //Disable the ability for the user to pick their choice after shoot is selected.
        [swipeRight setEnabled:NO];
        [swipeLeft setEnabled:NO];
        
        //Call the resetGame function after 3 seconds.
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(resetGame) userInfo:nil repeats:NO];
    }
    //Increment the counter.
    countdown++;
}

//Return to the initial game configuration.
- (void)resetGame
{
    //Re-enable the start button.
    [startButton setTitle:@"START" forState:UIControlStateNormal];
    [startButton setEnabled:YES];
    //Allow the user to pick their choice again.
    [swipeRight setEnabled:YES];
    [swipeLeft setEnabled:YES];
    //Hide the computer's choice again.
    [computerView setHidden:YES];
}
@end
