//
//  AudioViewController.h
//  Audio
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioViewController : UIViewController
   <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UISlider *volumeControl;
- (IBAction)stopAudio:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)adjustVolume:(id)sender;

@end
