//
//  TableState.m
//  CDI Viewer
//
//  Created by Chris Lesch on 1/18/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import "TableState.h"

@implementation TableState
- (BOOL)isEqual:(id)object{
    TableState *myObject = (TableState*)object;
    if([myObject.docID isEqualToString:_docID]){
        return YES;
    }
    return NO;
}
- (NSMutableDictionary*)dictForClass{
    NSArray *keys = [[NSArray alloc]initWithObjects:@"fileName",@"docID",@"renamed",nil];
    NSArray *objs = [[NSArray alloc]initWithObjects:_fileName,_docID,[NSNumber numberWithBool:_renamed],nil];
    return [[NSMutableDictionary alloc] initWithObjects:objs forKeys:keys];
}
@end
