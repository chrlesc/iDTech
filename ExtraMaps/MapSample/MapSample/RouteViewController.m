//
//  RouteViewController.m
//  MapSample
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   _routeMap.showsUserLocation = YES;
   MKUserLocation *userLocation = _routeMap.userLocation;
   MKCoordinateRegion region =
   MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 
          20000, 20000);
   [_routeMap setRegion:region animated:NO];
   _routeMap.delegate = self;
   [self getDirections];

}

- (void)getDirections
{
        MKDirectionsRequest *request = 
           [[MKDirectionsRequest alloc] init];

    request.source = [MKMapItem mapItemForCurrentLocation];

        request.destination = _destination;
        request.requestsAlternateRoutes = NO;
        MKDirections *directions = 
           [[MKDirections alloc] initWithRequest:request];

        [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
} 

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [_routeMap 
           addOverlay:route.polyline level:MKOverlayLevelAboveRoads];

        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = 
        [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
