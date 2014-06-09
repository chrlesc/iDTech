//
//  TableViewController.m
//  TableExamples
//
//  Created by Chris Lesch on 6/8/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "TableViewController.h"
#import "enterDataViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *personOne = @{@"name": @"Aang",
                                @"pet" : @"Appa"};
    NSDictionary *personTwo = @{@"name": @"Shaggy",
                                @"pet" : @"Scooby-Doo"};
    NSDictionary *personThree = @{@"name":@"Mark Wahlberg",
                                  @"pet":@"Ted"};
    NSDictionary *personFour = @{@"name":@"Tom Riddle",
                                 @"pet":@"Basilisk"};
    userArray = [[NSMutableArray alloc] initWithObjects:personOne,personTwo,personThree,personFour, nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                     forIndexPath:indexPath];
    
    NSDictionary *dictionary = [userArray objectAtIndex:[indexPath row]];
    
    [cell.usernameLabel setText:[dictionary objectForKey:@"name"]];
    [cell.petLabel setText:[dictionary objectForKey:@"pet"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    detailedViewController *userDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailedViewController"];
    
    NSDictionary *dictionary = [userArray objectAtIndex:indexPath.row];
    
    [userDetailsVC setUserDetails:dictionary];
    
    [self.navigationController pushViewController:userDetailsVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)addUser:(id)sender {
    enterDataViewController *addUserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"enterDataViewController"];
    [addUserVC setParentTableVC:self];
    [self.navigationController pushViewController:addUserVC animated:YES];
}
- (void)insertNewRow:(NSDictionary *)dictionary {
    [userArray addObject:dictionary];
    
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[userArray count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
@end
