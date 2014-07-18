//
//  rend.m
//  MapCircle
//
//  Created by Chris Lesch on 7/4/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "rend.h"

@implementation rend

-(void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    UIImage *image = [UIImage imageNamed:@"marker"];
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
   CGContextScaleCTM(context,1.0,-1.0);
   CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    
    CGContextDrawImage(context, theRect, imageReference);
}
@end
