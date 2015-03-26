//
//  MenuItemCell.m
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell

@synthesize labelMenu;


- (void)awakeFromNib
{
    
}



- (void) setTableCell:(NSString *)text
{
    labelMenu.text = text;
}

- (void) dealloc
{
    
    [labelMenu release];
    [super dealloc];
    
}

@end
