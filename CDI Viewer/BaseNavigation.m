//
//  BaseNavigation.m
//  CDI Viewer
//
//  Created by Chris Lesch on 1/14/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "BaseNavigation.h"
#import "Globals.h"
#import "TableCell.h"


@interface BaseNavigation ()

@end

@implementation BaseNavigation

/*Initialize the layout from the nib file
* */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_hello setHidden:YES];
    [_response setHidden:YES];
    [self loadDocuments];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification  object:nil];
}

- (void)loadDocuments{
    Globals *g = [Globals getInstance];
    self.states = [NSMutableArray arrayWithCapacity:1];
    self.statesTemp = [NSMutableArray arrayWithCapacity:1];
    NSArray *existingFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[g documentsBasePath] error:nil];
    NSArray *filteredFiles = [existingFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"]];
    for(id filename in filteredFiles)
    {
        NSString *filePath = [[g documentsBasePath] stringByAppendingString:filename];
        NSDictionary *fileData = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        TableState *aState = [[TableState alloc] init];
        aState.fileName = [fileData valueForKey:@"fileName"];
        aState.displayFileName = aState.fileName;
        aState.IDLabel = @"Doc ID: ";
        aState.docID = [fileData valueForKey:@"docID"];
        aState.renamed = [[fileData valueForKey:@"renamed"] boolValue];
        [self.statesTemp addObject:aState];
    }
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (TableState *theState in self.statesTemp) {
        NSInteger sect = [theCollation sectionForObject:theState collationStringSelector:@selector(docID)];
        theState.sectionNumber = sect;
    }
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    for (TableState *theState in self.statesTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:theState.sectionNumber] addObject:theState];
    }
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray
                                            collationStringSelector:@selector(docID)];
        [self.states addObject:sortedSection];
    }
}

#pragma mark - Table view data source
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.states objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.states count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.states objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = nil;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        tableIdentifier = @"TableCell_Ipad";
    }else{
        tableIdentifier = @"TableCell_Iphone";
    }
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:tableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    TableState *stateObj = [[self.states objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.fileName setText:stateObj.displayFileName];
    [cell.fileID setText:stateObj.docID];
    [cell.open setHidden:YES];
    [cell.del setHidden:YES];
    [cell.update setHidden:YES];
    [cell.editFileName setHidden:YES];
    //If the cell is one that is currently downloading set it as such.
    if([cell.fileName.text isEqualToString:@"Downloading..."]){
        [cell.progress setHidden:NO];
        [cell.fileName setTextColor:[UIColor lightGrayColor]];
        [cell setUserInteractionEnabled:NO];
        [cell.progress setProgress:[stateObj.progress floatValue] animated:NO];
    }else{
        [cell.progress setHidden:YES];
        [cell.fileName setTextColor:[UIColor blackColor]];
        [cell setUserInteractionEnabled:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 57;
    }else{
        return 36;
    }
}

/*Tell the keyboard to go away when the user presses return.
* */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
- (IBAction)SettingsSelected{
    Globals *g = [Globals getInstance];
    if(g.settings == nil){
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            g.settings = [[Settings alloc] initWithNibName:@"Settings_Ipad" bundle:[NSBundle mainBundle]];
        }else{
            g.settings = [[Settings alloc] initWithNibName:@"Settings_Iphone" bundle:[NSBundle mainBundle]];
        }
    }
    [self.navigationController pushViewController:g.settings animated:YES];
}
/*Handle case where the Login button is selected.
* */
- (IBAction)LoginSelected{
    Globals *g = [Globals getInstance];
    //Switch to the correct view controller if not currently logged in.
    if([[g.base.loginButton.titleLabel text]isEqualToString:@"Login"]){
        if(g.login == nil){
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                g.login = [[LoginView alloc] initWithNibName:@"LoginView_Ipad" bundle:[NSBundle mainBundle]];
            }else{
                g.login = [[LoginView alloc] initWithNibName:@"LoginView_Iphone" bundle:[NSBundle mainBundle]];
            }
        }
        [self.navigationController pushViewController:g.login animated:YES];
    }else{  //If there was an existing Login session delete it and its assoicated data. Also, update UI.
        [g.login deleteCookies];
        g.session = nil;
        g.login = nil;
        [g.base.hello setHidden:YES];
        [g.base.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

/*Removes the provided row from the table with a matching request hash.
 * */
- (void) removeRow:(TableState *)aState request_hash:(NSNumber*)request_hash{
    Globals *g = [Globals getInstance];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[g.base.states objectAtIndex:aState.sectionNumber]];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[sectionArray indexOfObject:aState] inSection:aState.sectionNumber];
    //Remove the object from the section of the table.
    [sectionArray removeObject:aState];
    if(sectionArray == nil)
        sectionArray = [NSMutableArray arrayWithCapacity:1];
    
    //Sort the new section.
    NSArray *sortedSection = [[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:sectionArray
                                                                          collationStringSelector:@selector(docID)];
    [g.base.states setObject:sortedSection atIndexedSubscript:aState.sectionNumber];
    if(request_hash)
        [g.currently_downloading removeObjectForKey:request_hash];
    if(ip){
        NSMutableArray *deleteRows = [NSMutableArray arrayWithObject:ip];
        [g.base.table deleteRowsAtIndexPaths:deleteRows withRowAnimation:UITableViewRowAnimationFade];
    }
}
/*Add a row to the table given the table State object.
* */
- (TableState *) addRow:(TableState *) aState{
    Globals *g = [Globals getInstance];
    [aState setProgress:[NSNumber numberWithFloat:0.0]];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[g.base.states objectAtIndex:aState.sectionNumber]];
    //If the file already exists, just show that it is downloading now.
    if([sectionArray containsObject:aState]){
        TableState *prev = [sectionArray objectAtIndex:[sectionArray indexOfObject:aState]];
        [prev setProgress:[NSNumber numberWithFloat:0.0]];
        [prev setDisplayFileName:@"Downloading..."];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:[sectionArray indexOfObject:prev] inSection:prev.sectionNumber];
        if(ip){
            NSMutableArray *reloadRows = [NSMutableArray arrayWithObject:ip];
            [g.base.table reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
        }
        return prev;
    }
    
    //If the file doesn't already exist do this.
    [sectionArray addObject:aState];
    NSArray *sortedSection = [[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:sectionArray
                                                                          collationStringSelector:@selector(docID)];
    [g.base.states setObject:sortedSection atIndexedSubscript:aState.sectionNumber];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[sortedSection indexOfObject:aState] inSection:aState.sectionNumber];
    if(ip){
        NSMutableArray *addRows = [NSMutableArray arrayWithObject:ip];
        [g.base.table insertRowsAtIndexPaths:addRows withRowAnimation:UITableViewRowAnimationFade];
    }
    return aState;
}

/*Add a row to the table given information about the table state object.
* */
- (TableState *) addRow:(NSString *)fileName docID:(NSString *)docID IDLabel:(NSString *)IDLabel{
    TableState *aState = [[TableState alloc] init];
    aState.displayFileName = fileName;
    aState.IDLabel = IDLabel;
    aState.docID = docID;
    aState.renamed = NO;
    aState.sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:aState collationStringSelector:@selector(docID)];
    return [self addRow:aState];
}

//-------------------------Handle displaying the keyboard------------------------------
- (void)keyboardDidShow:(NSNotification*)notification{
    [self animateTextField:notification up:YES];
}

- (void)keyboardDidHide:(NSNotification*)notification{
    [self animateTextField:notification up:NO];
}

- (void) animateTextField:(NSNotification*)notification up:(BOOL)up
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
        int movementDistance;
        //Keyboard is coming up.
        if(up){
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            if(orientation == UIDeviceOrientationLandscapeRight){
                movementDistance = keyboardFrameEndRect.origin.x;
            }else if(orientation == UIDeviceOrientationLandscapeLeft){
                movementDistance = ([self view].frame.size.height - keyboardFrameEndRect.size.width);
            }else if(orientation == UIDeviceOrientationPortrait){
                movementDistance = keyboardFrameEndRect.origin.y;
            }else{
                movementDistance = ([self view].frame.size.height - keyboardFrameEndRect.size.height);
            }
            movementDistance -= (_documentID.frame.origin.y + _documentID.frame.size.height);
            //If the keyboard isn't covering anything, than don't bother moving anything.
            if(movementDistance > 0){
                movementDistance = 0;
            }else{ //Add some extra padding to make things look nice.
                movementDistance = movementDistance - 5;
            }
            downDistance = -movementDistance;
        }else{ //Keyboard is going down.
            movementDistance = downDistance;
        }
        const float movementDuration = 0.3f;
        botConstraint.constant -= movementDistance;
       // topConstraint.constant -= movementDistance;
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        [self.view layoutIfNeeded];
        [UIView commitAnimations];
    }
}


//-------------------------Download Document Functions---------------------------------
- (void)removeResponseMessage{
    [_response setHidden:YES];
}

- (void) downloadDocument:(NSString *)docID{
    Globals *g = [Globals getInstance];
    [_response setHidden:YES];
    
    //Check if the user is logged in or not.
    if(g.session == nil){
        _response.text = @"Please Log-In";
        [_response setHidden:NO];
        [self performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
        return;
    }
    
    //Check if the user has selected wifi-only download as a network connection option.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    NSLog(@"WIFI-ONLY: %d",[userDefaults boolForKey:@"wifi_only"]);
    if(status == NotReachable)
    {
        _response.text = @"No Internet Connection Found";
        [_response setHidden:NO];
        [self performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
        return;
    }
    else if([userDefaults boolForKey:@"wifi_only"] == YES && status == ReachableViaWWAN){
        _response.text = @"Download over WiFi only option is ON";
        [_response setHidden:NO];
        [self performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
        return;
    }
    [reachability stopNotifier];
    
    NSString *urlString = [[@"http://www.intel.com/cd/edesign/library/asmo-na/eng/" stringByAppendingString:docID] stringByAppendingString:@".htm"];
    NSURL *pdfURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:pdfURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"www.intel.com" forHTTPHeaderField:@"Host"];
    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"en-US,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    
    if(g.currently_downloading == nil){
        g.currently_downloading = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    //If there is currently a pending download for this file, dont let another take place.
    if([g.currently_downloading objectForKey:[NSNumber numberWithInteger:request.hash]]){
        _response.text = @"File already pending...";
        [_response setHidden:NO];
        [self performSelector:@selector(removeResponseMessage) withObject:nil afterDelay:2.0];
        return;
    }
    
    TableState *aState = [self addRow:@"Downloading..." docID:docID IDLabel:@"Doc ID: "];
    [g.currently_downloading setObject:aState forKey:[NSNumber numberWithInteger:request.hash]];
    
    NSURLSessionDownloadTask *dTask = [g.session downloadTaskWithRequest:request];
    [dTask resume];
}
/*Downloads the pdf corresponding to docID to the apps documents directory.
 * */
- (IBAction)downloadDocument{
    if(_documentID.isFirstResponder){
        [_documentID resignFirstResponder];
    }
    NSString *docID = [NSString stringWithString:_documentID.text];
    [self downloadDocument:docID];
}
@end
