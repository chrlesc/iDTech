//
//  ViewController.m
//  MapCircle
//
//  Created by Chris Lesch on 7/4/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"
#import "rend.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    rend *mapRend = [[rend alloc] initWithOverlay:overlay];
    return mapRend;
}
- (IBAction)addCircle:(id)sender {
    CLLocationCoordinate2D pinCoordinate = {33.8090, -117.9190};
    int radius = 100000;
    //Make the actual overlay
    MKCircle *circ = [MKCircle circleWithCenterCoordinate:pinCoordinate radius:radius];
    [self.mapView addOverlay:circ];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pinCoordinate, radius, radius);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
@end
