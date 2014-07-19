//
//  ConnectionsViewController.m
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/18/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "DeviceListTableCell.h"
#import "Global.h"

@interface ConnectionsViewController ()

@end

@implementation ConnectionsViewController

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Global getConnectionManager];
    [manager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [manager advertiseSelf:_discoveryModeSwitch.isOn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerDidChangeState:) name:@"MCDidChangeStateNotification" object:nil];
    
    _table.delegate = self;
    _table.dataSource = self;
	
    connectedDevices = [[NSMutableArray alloc] init];
    [Global setConnectionsVC:self];
    [_discoveryName setDelegate:self];
    [_disconnectBtn setEnabled:NO];
}
-(void)peerDidChangeState:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = [[NSString alloc] initWithString:peerID.displayName];
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    if(state == MCSessionStateConnecting){
        return;
    }
    if(state == MCSessionStateConnected){
        [connectedDevices addObject:peerDisplayName];
    } else if(state == MCSessionStateNotConnected){
        if([connectedDevices count] > 0){
            int peerIndex = [connectedDevices indexOfObject:peerDisplayName];
            [connectedDevices removeObjectAtIndex:peerIndex];
        }
    }
	[_table reloadData];
    BOOL peersExist = ([manager.session connectedPeers].count == 0);
    [_disconnectBtn setEnabled:peersExist];
    [_discoveryName setEnabled:peersExist];
}
- (IBAction)Browse:(id)sender {
    [manager setupMCBrowser];
    [[manager browser] setDelegate:self];
    [self presentViewController:[manager browser] animated:YES completion:nil];
}
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [manager.browser dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [manager.browser dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    manager.peerID = nil;
    manager.session = nil;
    manager.browser = nil;
    if(_discoveryModeSwitch.isOn){
        [manager.advertiser stop];
    }
    manager.advertiser = nil;
    
    [manager setupPeerAndSessionWithDisplayName:_discoveryName.text];
    [manager setupMCBrowser];
    [manager advertiseSelf:_discoveryModeSwitch.isOn];
    return YES;
}
- (IBAction)Discover:(id)sender {
    [manager advertiseSelf:_discoveryModeSwitch.isOn];
}

- (IBAction)Disconnect:(id)sender {
    [manager.session disconnect];
    _discoveryName.enabled = YES;
    [connectedDevices removeAllObjects];
    [_table reloadData];
}
/*----Table Setup----*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [connectedDevices count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceListTableCell *cell = [tableView dequeueReusableCellWithIdentifier: @"deviceListTableCell" forIndexPath:indexPath];
    cell.deviceName.text = [connectedDevices objectAtIndex:indexPath.row];
    return cell;
}
@end
