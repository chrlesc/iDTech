//
//  MessageTableCell.m
//  PeerCommunicationDemo
//
//  Created by Chris Lesch on 7/22/14.
//  Copyright (c) 2014 iD Tech. All rights reserved.
//

#import "MessageTableCell.h"

@implementation MessageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
