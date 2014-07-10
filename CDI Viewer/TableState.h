//
//  TableState.h
//  CDI Viewer
//
//  Created by Chris Lesch on 1/18/14.
//  Copyright (c) 2014 Chris Lesch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableState : NSObject
@property(nonatomic,copy) NSString *fileName;
@property(nonatomic,copy) NSString *displayFileName;
@property(nonatomic,copy) NSString *IDLabel;
@property(nonatomic,copy) NSString *docID;
@property(nonatomic, retain)NSNumber *progress;
//Used when downloading the file to determine if it should take web scrapped name or keep its old name.
@property(nonatomic) BOOL renamed;
@property NSInteger sectionNumber;
- (BOOL)isEqual:(id)object;
- (NSMutableDictionary*)dictForClass;
@end
