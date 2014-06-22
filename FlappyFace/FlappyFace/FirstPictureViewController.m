//
//  FirstPictureViewController.m
//  FlappyFace
//
//  Created by Chris Lesch on 6/21/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "FirstPictureViewController.h"

@interface FirstPictureViewController ()

@end

@implementation FirstPictureViewController 

- (void)viewDidLoad
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) takeApicture:(id)sender{
    //Check if the camera is available for app usage.
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        //Create a new image controller.
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        self.newMedia = YES;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //Cageify the image
        
        self.imageView.image = image;
       [self cageify:image];
        if (self.newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
}

- (void) cageify:(UIImage *)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *myImage = image.CIImage;
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh ,
                            CIDetectorImageOrientation : [[myImage properties] valueForKey:(NSString *)kCGImagePropertyOrientation]};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:context
                                              options:opts];
    
    NSArray *features = [detector featuresInImage:myImage options:opts];
    
    for (CIFaceFeature *f in features)
    {
        UIView *faceView = [[UIView alloc]initWithFrame:f.bounds];
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor orangeColor] CGColor];
        [self.view addSubview:faceView];
        
    /*    if (f.hasLeftEyePosition)
            NSLog("Left eye %g %g", f.leftEyePosition.x. f.leftEyePosition.y);
        
        if (f.hasRightEyePosition)
            NSLog("Right eye %g %g", f.rightEyePosition.x. f.rightEyePosition.y);
        
        if (f.hasmouthPosition)
            NSLog("Mouth %g %g", f.mouthPosition.x. f.mouthPosition.y);*/
    }

}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (IBAction)useCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}*/
@end
