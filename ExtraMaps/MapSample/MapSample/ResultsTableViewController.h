//
//  ResultsTableViewController.h
//  MapSample
//
//  Created by Neil Smyth on 9/20/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ResultsTableCell.h"
#import "RouteViewController.h"

@interface ResultsTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *mapItems;
@end
