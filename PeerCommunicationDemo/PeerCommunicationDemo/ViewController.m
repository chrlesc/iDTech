//
//  ViewController.m
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"
#import "SettingsMenuTableCell.h"

#define ROW_HEIGHT 40.0f

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shadedView.alpha = .65;
    [self initSettingsTable];
    UINib *nib = [UINib nibWithNibName:@"SettingsMenuTableCell" bundle:[NSBundle mainBundle]];
    [_settingsTable registerNib:nib forCellReuseIdentifier:@"settingsMenuTableCell"];
}
- (void)initSettingsTable{
    CGFloat tableY = MAX(self.view.bounds.size.height/2.0f,self.view.bounds.size.height-(2.0f*ROW_HEIGHT));
    CGFloat tableX = self.view.bounds.size.width/16.0f;
    CGFloat tableWidth = self.view.bounds.size.width*(14.0f/16.0f);
    CGFloat tableHeight = MIN(2.0f*ROW_HEIGHT,self.view.bounds.size.height/2.0f);
    _settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(tableX,tableY,tableWidth,tableHeight) style:UITableViewStyleGrouped];
    _settingsTable.hidden = YES;
    _settingsTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _settingsTable.bounds.size.width, 0.01f)];
    _settingsTable.backgroundColor = [UIColor blackColor];
    [_settingsTable setDataSource:self];
    [_settingsTable setDelegate:self];
    [self.view addSubview:_settingsTable];

}
/*----TableView Delegate and Protocal Functions----*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

    
//Returns a pre-defined value that is set based on our created nib file.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier: @"settingsMenuTableCell" forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:@"Settings"];
    cell.label.text = @"HI";
    return cell;
}
/*----Menu Gesture Actions-----*/
- (IBAction)PullUpMenu:(id)sender {
    _shadedView.backgroundColor = [UIColor blackColor];
    _settingsTable.hidden = NO;
   // NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    //[_settingsTable selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
    [_settingsTable becomeFirstResponder];
}

- (IBAction)tapToCloseMenu:(id)sender {
    _shadedView.backgroundColor = [UIColor clearColor];
    _settingsTable.hidden = YES;
}
@end
