//
//  ViewController.m
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ViewController.h"
#import "SettingsMenuTableCell.h"
#import "Global.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shadedView.alpha = .65;
    _shadedView.hidden = YES;
    settingsArray = [Global getSettingsArray];
    [settingsArray addObject:@{@"Title" : @"Settings",@"ImageName" : @"Settings"}];
    
}
- (void) viewWillLayoutSubviews {
    [self initSettingsTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [self tapToCloseMenu:nil];
}
- (void)initSettingsTable{
    if(_settingsTable){
        [_settingsTable removeFromSuperview];
    }
    int rowHeight = self.view.bounds.size.height/10.0f;
    CGFloat tableY = MAX(self.view.bounds.size.height/2.0f,self.view.bounds.size.height-(settingsArray.count*rowHeight));
    CGFloat tableX = self.view.bounds.size.width/16.0f;
    CGFloat tableWidth = self.view.bounds.size.width*(14.0f/16.0f);
    CGFloat tableHeight = MIN(settingsArray.count*rowHeight,self.view.bounds.size.height/2.0f);
    _settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(tableX,tableY,tableWidth,tableHeight) style:UITableViewStyleGrouped];
    _settingsTable.hidden = YES;
    _settingsTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _settingsTable.bounds.size.width, 0.01f)];
    _settingsTable.backgroundColor = [UIColor blackColor];
    _settingsTable.scrollEnabled = NO;
    [_settingsTable setDataSource:self];
    [_settingsTable setDelegate:self];
    
    
    //UINib *nib = [UINib nibWithNibName:@"SettingsMenuTableCell" bundle:[NSBundle mainBundle]];
   // [_settingsTable registerNib:nib forCellReuseIdentifier:@"settingsMenuTableCell"];
    
    [self.view addSubview:_settingsTable];

}
/*----TableView Delegate and Protocal Functions----*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

    
//Returns a pre-defined value that is set based on our created nib file.
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.height/10.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingsArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [settingsArray objectAtIndex:indexPath.row];
    NSString *title = [dictionary objectForKey:@"Title"];
    if([title isEqualToString:@"Settings"]){
        ConnectionsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"connectionsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Grab the dictionary to use to populate this particular row.
    NSDictionary *dictionary = [settingsArray objectAtIndex:indexPath.row];
    
    // SettingsMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier: @"settingsMenuTableCell" forIndexPath:indexPath];
    int rowHeight = self.view.bounds.size.height/10.0f;
    CGFloat tableWidth = self.view.bounds.size.width*(14.0f/16.0f);
    //Grab width and height of table.
    SettingsMenuTableCell *cell = [[SettingsMenuTableCell alloc] init];
    //Add the imageView to the table.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,tableWidth*0.15,rowHeight)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = [UIImage imageNamed:[dictionary objectForKey:@"ImageName"]];
    cell.image = imageView;
    [cell addSubview:imageView];
    
    //Add the label to the the table.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableWidth*0.2, 0, tableWidth*0.8, rowHeight)];
    cell.label = label;
    cell.label.text = [dictionary objectForKey:@"Title"];
    cell.label.textColor = [UIColor whiteColor];
    [cell addSubview:label];
    
    //Configure global settings.
    cell.backgroundColor = [UIColor darkGrayColor];
    return cell;
}
/*----Menu Gesture Actions-----*/
- (IBAction)PullUpMenu:(id)sender {
    _shadedView.hidden = NO;
    _shadedView.backgroundColor = [UIColor blackColor];
    [_settingsTable reloadData];
    _settingsTable.hidden = NO;
}

- (IBAction)tapToCloseMenu:(id)sender {
    _shadedView.hidden = YES;
    _shadedView.backgroundColor = [UIColor clearColor];
    _settingsTable.hidden = YES;
}
@end
