//
//  detailedViewController.h
//  TableExamples
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *petLabel;
@property (strong, nonatomic) NSDictionary *userDetails;
@end
