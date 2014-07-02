//
//  FirstPictureViewController.h
//  FlappyFace
//
//  Created by Chris Lesch on 6/21/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@interface FirstPictureViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIImage *image;
    NSMutableArray *cageFaces;
}
- (IBAction)takeApicture:(id)sender;
- (CGPoint) fromPoint:(CGPoint)originalPoint;
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void) cageify;
@end
