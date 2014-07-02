//
//  MapSampleViewController.m
//  MapSample
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import "MapSampleViewController.h"

@interface MapSampleViewController ()

@end

@implementation MapSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
       MKCoordinateRegionMakeWithDistance (
          userLocation.location.coordinate, 20000, 20000);
    [_mapView setRegion:region animated:NO];
}

- (IBAction)changeMaptype:(id)sender {
    if (_mapView.mapType == MKMapTypeStandard)
        _mapView.mapType = MKMapTypeSatellite;
    else
        _mapView.mapType = MKMapTypeStandard;

}

- (void)mapView:(MKMapView *)mapView 
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = 
          userLocation.location.coordinate;
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [_mapView removeAnnotations:[_mapView annotations]];
    [self performSearch];
}

- (void) performSearch {
    MKLocalSearchRequest *request = 
          [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchText.text;
    request.region = _mapView.region;

    _matchingItems = [[NSMutableArray alloc] init];

    MKLocalSearch *search = 
        [[MKLocalSearch alloc]initWithRequest:request];

    [search startWithCompletionHandler:^(MKLocalSearchResponse 
       *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                [_matchingItems addObject:item];
                MKPointAnnotation *annotation = 
                     [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [_mapView addAnnotation:annotation];
            }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsTableViewController *destination = 
               [segue destinationViewController];

    destination.mapItems = _matchingItems;
}

@end
