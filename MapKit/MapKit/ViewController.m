//
//  ViewController.m
//  MapKit
//
//  Created by Chris Lesch on 6/9/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    alert = [[UIAlertView alloc] initWithTitle:@"Delete Pins" message:@"Would you like to delete all pins on the map?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    CLLocationCoordinate2D pinCoordinate = {33.8090, -117.9190};
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    [point setTitle:@"Disneyland"];
    [point setCoordinate:pinCoordinate];
    
    [self.mapView addAnnotation:point];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)longPress:(id)sender
{
    if(self.mapView.annotations.count > 0){
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == (NSInteger)1){
        for (id annotation in self.mapView.annotations) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}
@end
