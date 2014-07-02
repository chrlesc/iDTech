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
    cageFaces = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) takeApicture:(id)sender{
    for(int i = 0 ; i < cageFaces.count; i++){
        UIView *face = [cageFaces objectAtIndex:i];
        [face removeFromSuperview];
    }
    [cageFaces removeAllObjects];
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
        image = info[UIImagePickerControllerOriginalImage];
        
        //Cageify the image
        self.imageView.image = image;
        [self cageify];
        //Save code.
       /* if (self.newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);*/
    }
}

- (void) cageify{
    int exifOrientation;
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }
    
    NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }; // TODO: read doc for more tuneups
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    NSArray *features = [faceDetector featuresInImage:[CIImage imageWithCGImage:self.imageView.image.CGImage]
                                              options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:exifOrientation]}];
    
    for (CIFaceFeature *f in features)
    {
        // Translate CoreImage coordinates to UIKit coordinates
        CGPoint origin = [self fromPoint:f.bounds.origin];
        CGRect faceRect = CGRectMake(origin.x,origin.y,f.bounds.size.width,f.bounds.size.height);
        CGSize originalSize = [image size];
        CGSize currentSize = self.imageView.bounds.size;
        CGFloat widthScale = currentSize.width/originalSize.width;
        CGFloat heightScale = currentSize.height/originalSize.height;
        CGFloat eyeDistance = (f.rightEyePosition.x - f.leftEyePosition.x)*widthScale;
        CGFloat eyeMouthDistance = (f.rightEyePosition.y - f.mouthPosition.y)*heightScale;
       /* float angle = 0.f;
        if (f.leftEyePosition.x != f.rightEyePosition.x) {
            angle = atan2(f.leftEyePosition.y - f.rightEyePosition.y,f.leftEyePosition.x - f.rightEyePosition.x);
        }*/
        faceRect = CGRectMake(faceRect.origin.x*widthScale-eyeDistance, faceRect.origin.y*heightScale-2*eyeMouthDistance, faceRect.size.width*widthScale+2*eyeDistance, faceRect.size.height*heightScale+2*eyeMouthDistance);
        

        UIImageView *cageFace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nicolasCage"]];
        [cageFace setFrame:faceRect];
        [cageFace setContentMode:UIViewContentModeScaleAspectFit];
        [cageFaces addObject:cageFace];
        //Rotate the face
      //  CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
      //  cageFace.transform = transform;
        [self.imageView addSubview:cageFace];
    }
}
- (CGPoint) fromPoint:(CGPoint) originalPoint {
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGPoint convertedPoint;
    
    switch (image.imageOrientation) {
        case UIImageOrientationUp:
            convertedPoint.x = originalPoint.x;
            convertedPoint.y = imageHeight - originalPoint.y;
            break;
        case UIImageOrientationDown:
            convertedPoint.x = imageWidth - originalPoint.x;
            convertedPoint.y = originalPoint.y;
            break;
        case UIImageOrientationLeft:
            convertedPoint.x = imageWidth - originalPoint.y;
            convertedPoint.y = imageHeight - originalPoint.x;
            break;
        case UIImageOrientationRight:
            convertedPoint.x = originalPoint.y;
            convertedPoint.y = originalPoint.x;
            break;
        case UIImageOrientationUpMirrored:
            convertedPoint.x = imageWidth - originalPoint.x;
            convertedPoint.y = imageHeight - originalPoint.y;
            break;
        case UIImageOrientationDownMirrored:
            convertedPoint.x = originalPoint.x;
            convertedPoint.y = originalPoint.y;
            break;
        case UIImageOrientationLeftMirrored:
            convertedPoint.x = imageWidth - originalPoint.y;
            convertedPoint.y = originalPoint.x;
            break;
        case UIImageOrientationRightMirrored:
            convertedPoint.x = originalPoint.y;
            convertedPoint.y = imageHeight - originalPoint.x;
            break;
        default:
            break;
    }
    return convertedPoint;
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
