//
//  AudioViewController.m
//  Audio
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
            pathForResource:@"Moderato"
            ofType:@"mp3"]];

        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]
                         initWithContentsOfURL:url
                         error:&error];
        if (error)
        {
                NSLog(@"Error in audioPlayer: %@",
                      [error localizedDescription]);
        } else {
                _audioPlayer.delegate = self;
                [_audioPlayer prepareToPlay];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopAudio:(id)sender {
    [_audioPlayer stop];
}

- (IBAction)playAudio:(id)sender {
    [_audioPlayer play];
}

- (IBAction)adjustVolume:(id)sender {
    if (_audioPlayer != nil)
    {
        _audioPlayer.volume = _volumeControl.value;
    }
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player error:(NSError *)error
{
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
}

@end
