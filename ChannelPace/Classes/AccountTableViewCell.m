//
//  AccountTableViewCell.m
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "AccountTableViewCell.h"


@implementation AccountTableViewCell
@synthesize accountImage;

- (void)awakeFromNib
{
    // Initialization code
    accountImage = [[DBImageView alloc] initWithFrame:CGRectMake(17, 0, 75, 80)];
    
        
    [self addSubview:accountImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
