//
//  TableViewController.h
//  TableExamples
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCell.h"
#import "detailedViewController.h"

@interface TableViewController : UITableViewController{
    NSMutableArray* userArray;
}
- (IBAction)addUser:(id)sender;
- (void)insertNewRow:(NSDictionary *)dictionary;
@end
