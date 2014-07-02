//
//  RouteViewController.h
//  MapSample
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteViewController : UIViewController
   <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *routeMap;
@property (strong, nonatomic) MKMapItem *destination;
@end
