//
//  ViewController.h
//  MapKit
//
//  Created by Chris Lesch on 6/9/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>{
    UIAlertView *alert;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)longPress:(id)sender;

@end
