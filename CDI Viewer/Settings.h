//
//  Settings.h
//  CDI Viewer
//
//  Created by Chris Lesch on 2/5/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings: UIViewController{
    BOOL prev_wifi_only;
}
@property(nonatomic,retain)IBOutlet UISwitch *wifi_only;
- (IBAction)wifi_update;
- (IBAction)back;
@end
