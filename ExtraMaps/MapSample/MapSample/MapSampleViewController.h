//
//  MapSampleViewController.h
//  MapSample
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ResultsTableViewController.h"

@interface MapSampleViewController : UIViewController
<MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *matchingItems;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMaptype:(id)sender;
- (IBAction)textFieldReturn:(id)sender;

@end
