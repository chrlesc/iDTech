//
//  TableCell.m
//  CDI Viewer
//
//  Created by Chris Lesch on 1/15/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "TableCell.h"
#import "Globals.h"

@implementation TableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [_open setHidden:YES];
    [_del setHidden:YES];
    [_update setHidden:YES];
    // Configure the view for the selected state
}

- (IBAction)swipeRight:(UISwipeGestureRecognizer *)swipe{
    BOOL hide;
    if(_open.hidden){
        hide = NO;
    }else{
        hide = YES;
    }
    [_open setHidden:hide];
    [_del setHidden:hide];
    [_update setHidden:hide];
}

- (IBAction)longPress:(UILongPressGestureRecognizer *)press{
    if([_editFileName isFirstResponder] == NO){
        [_fileName setHidden:YES];
        [_editFileName setText:_fileName.text];
        [_editFileName setHidden:NO];
        [_editFileName becomeFirstResponder];
    }
}

-(IBAction)Onetap:(UITapGestureRecognizer *)tap{
    if(!_open.hidden){
        [_open setHidden:YES];
        [_del setHidden:YES];
        [_update setHidden:YES];
        return;
    }
    Globals *g = [Globals getInstance];
    NSString *pdfName = [[[g documentsBasePath] stringByAppendingString:_fileID.text] stringByAppendingString:@".pdf"];
    CGDataProviderRef ref = CGDataProviderCreateWithFilename([pdfName UTF8String]);
    MFDocumentManager *documentManager = [[MFDocumentManager alloc] initWithDataProvider:ref];
    g.documentViewController = [[DocumentViewController alloc] initWithDocumentManager:documentManager];
    [g.base.navigationController pushViewController:g.documentViewController animated:YES];
}

- (IBAction)exitEditText:(id)sender{
    //Update the UI.
    UITextField *theTextField = (UITextField*)sender;
    [theTextField setHidden:YES];
    [_fileName setText:theTextField.text];
    [_fileName setHidden:NO];
    [theTextField resignFirstResponder];
    //Update the currently in memory copy of the table state.
    Globals *g = [Globals getInstance];
    TableState *aState = [[TableState alloc] init];
    aState.docID = _fileID.text;
    aState.sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:aState collationStringSelector:@selector(docID)];
    NSArray *sectionArray = [g.base.states objectAtIndex:aState.sectionNumber];
    TableState *temp = [sectionArray objectAtIndex:[sectionArray indexOfObject:aState]];
    temp.fileName = _fileName.text;
    temp.displayFileName = _fileName.text;
    temp.renamed = YES;
    //Save the changes to disk.
    NSString *documentsDirectory = [g documentsBasePath];
    NSString *writePath = [[documentsDirectory stringByAppendingString:temp.docID] stringByAppendingString:@".txt"];
    [[temp dictForClass] writeToFile:writePath atomically:YES];
}

/*Open the selected document using the open-in feature.
* */
- (IBAction)openDoc{
    Globals *g = [Globals getInstance];
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[[g documentsBasePath] stringByAppendingString:_fileID.text] stringByAppendingPathExtension:@"pdf"]];
    docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    docController.delegate = g.base;
    docController.UTI = @"com.adobe.pdf";
    TableState *aState = [[TableState alloc] init];
    aState.fileName = _fileName.text;
    aState.IDLabel = @"Doc ID: ";
    aState.docID = _fileID.text;
    aState.sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:aState collationStringSelector:@selector(docID)];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[g.base.states objectAtIndex:aState.sectionNumber]];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[sectionArray indexOfObject:aState] inSection:aState.sectionNumber];
    CGRect rect = [g.base.table rectForRowAtIndexPath:ip];
    rect = [g.base.table convertRect:rect toView:g.base.view];
    [docController presentOpenInMenuFromRect:rect inView:g.base.view animated:YES];
}

/*Remove the selected document from the file system, and update the table to show this change.
* */
- (IBAction)deleteDoc{
    Globals *g = [Globals getInstance];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[[g documentsBasePath] stringByAppendingString:_fileID.text] stringByAppendingPathExtension:@"pdf"];
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:filePath error:&error];
    filePath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
    BOOL success2 =[fileManager removeItemAtPath:filePath error:&error];
    if(success && success2){
        TableState *aState = [[TableState alloc] init];
        aState.fileName = _fileName.text;
        aState.IDLabel = @"Doc ID: ";
        aState.docID = _fileID.text;
        aState.sectionNumber = [[UILocalizedIndexedCollation currentCollation] sectionForObject:aState collationStringSelector:@selector(docID)];
        [g.base removeRow:aState request_hash:nil];
    }else{
        NSLog(@"Couldn't delete file!");
    }
}

- (IBAction)updateDoc{
    Globals *g = [Globals getInstance];
    NSString *docID = [NSString stringWithString:_fileID.text];
    [g.base downloadDocument:docID];
}
@end
