//
//  LocationViewController.m
//  Location
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _startLocation = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetDistance:(id)sender {
        _startLocation = nil;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
                  fromLocation:(CLLocation *)oldLocation
{
     NSString *currentLatitude = [[NSString alloc] 
                  initWithFormat:@"%+.6f", 
                  newLocation.coordinate.latitude];
     _latitude.text = currentLatitude;

     NSString *currentLongitude = [[NSString alloc] 
          initWithFormat:@"%+.6f",
          newLocation.coordinate.longitude];
     _longitude.text = currentLongitude;

     NSString *currentHorizontalAccuracy = 
              [[NSString alloc] 
             initWithFormat:@"%+.6f",
             newLocation.horizontalAccuracy];
     _horizontalAccuracy.text = currentHorizontalAccuracy;

     NSString *currentAltitude = [[NSString alloc] 
                  initWithFormat:@"%+.6f",                                                          
                  newLocation.altitude];
     _altitude.text = currentAltitude;

     NSString *currentVerticalAccuracy = 
              [[NSString alloc] 
              initWithFormat:@"%+.6f",
              newLocation.verticalAccuracy];
     _verticalAccuracy.text = currentVerticalAccuracy;

     if (_startLocation == nil)
            _startLocation = newLocation;
       
     CLLocationDistance distanceBetween = [newLocation
            distanceFromLocation:_startLocation];

     NSString *tripString = [[NSString alloc] 
           initWithFormat:@"%f", 
           distanceBetween];
     _distance.text = tripString;
}

-(void)locationManager:(CLLocationManager *)manager 
didFailWithError:(NSError *)error
{
}


@end
