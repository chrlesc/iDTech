//
//  CoreDataViewController.m
//  CoreData
//
//  Created by Neil Smyth on 9/18/13.
//  Copyright (c) 2013 Neil Smyth. All rights reserved.
//

#import "CoreDataViewController.h"

@interface CoreDataViewController ()

@end

@implementation CoreDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveData:(id)sender {
    CoreDataAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

   NSManagedObjectContext *context = [appDelegate managedObjectContext];
   NSManagedObject *newContact;
   newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Bookmark" inManagedObjectContext:context];
   [newContact setValue: _bookmarkName.text forKey:@"bookmarkName"];
   [newContact setValue: _lattitude.text forKey:@"lattitude"];
   [newContact setValue: _longitude.text forKey:@"longitude"];
   _bookmarkName.text = @"";
   _lattitude.text = @"";
   _longitude.text = @"";
   NSError *error;
   [context save:&error];
   _status.text = @"Contact saved";

}

- (IBAction)findContact:(id)sender {
    CoreDataAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:context];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(bookmarkName CONTAINS %@)", _bookmarkName.text];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;

    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    if ([objects count] == 0) {
       _status.text = @"No matches";
    } else {
       matches = objects[0];
       _lattitude.text = [matches valueForKey:@"lattitude"];
       _longitude.text = [matches valueForKey:@"longitude"];
       _status.text = [NSString stringWithFormat:
           @"%lu matches found", (unsigned long)[objects count]];
    }
}
@end
