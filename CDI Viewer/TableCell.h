//
//  TableCell.h
//  CDI Viewer
//
//  Created by Chris Lesch on 1/15/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableState.h"
#import <FastPdfKit/FastPdfKit.h>

@interface TableCell : UITableViewCell{
    UIDocumentInteractionController *docController;
    TableState *t;
}
@property(nonatomic, weak)IBOutlet UILabel *fileName;
@property(nonatomic, weak)IBOutlet UITextField *editFileName;
@property(nonatomic, weak)IBOutlet UILabel *fileID;
@property(nonatomic, weak)IBOutlet UIButton *open;
@property(nonatomic, weak)IBOutlet UIButton *del;
@property(nonatomic, weak)IBOutlet UIButton *update;
@property(atomic, retain)IBOutlet UIProgressView *progress;

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)swipe;
- (IBAction)longPress:(UILongPressGestureRecognizer *)press;
- (IBAction)Onetap:(UITapGestureRecognizer *)tap;
- (IBAction)openDoc;
- (IBAction)deleteDoc;
- (IBAction)updateDoc;

- (IBAction)exitEditText:(id)sender;

@end
