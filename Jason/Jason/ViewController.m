//
//  ViewController.m
//  Jason
//
//  Created by Chris Lesch on 7/11/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *host = @"http://us.battle.net";
    NSString *characterInfo = @"/api/wow/character/terokkar/Volentus";
	// Do any additional setup after loading the view, typically from a nib.
    NSURL* myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,characterInfo ]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData *data = [NSData dataWithContentsOfURL:myURL];
        NSError *error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *Name = [json objectForKey:@"name"];
        NSString *Thumbnail = [json objectForKey:@"thumbnail"];
        NSString *profileMain = [[Thumbnail substringToIndex:[Thumbnail rangeOfString:@"avatar"].location] stringByAppendingString:@"profilemain.jpg"];
        NSLog(@"Name: %@, Thumbnail: %@",Name,Thumbnail);
        NSString *render = @"/static-render/us/";
        NSString *imageLoc = [NSString stringWithFormat:@"%@%@%@",host,render,profileMain];
        NSURL *imageURL = [NSURL URLWithString:imageLoc];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            //Need to perform updates back on the main queue :/.
            [self performSelectorOnMainThread:@selector(displayImage:)
                                   withObject:imageData waitUntilDone:YES];
        });
    });

}
-(void)displayImage:(NSData*)imageData{
    self.thumbnailImage.image = [UIImage imageWithData:imageData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
