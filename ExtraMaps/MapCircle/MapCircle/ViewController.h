//
//  ViewController.h
//  MapCircle
//
//  Created by Chris Lesch on 7/4/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
- (IBAction)addCircle:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
