//
//  FirstPictureViewController.h
//  FlappyFace
//
//  Created by Chris Lesch on 6/21/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>

@interface FirstPictureViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)takeApicture:(id)sender;
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void) cageify:(UIImage *)image;
@end
