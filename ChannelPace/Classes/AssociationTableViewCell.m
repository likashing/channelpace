//
//  AssociationTableViewCell.m
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "AssociationTableViewCell.h"
#import "AppDelegate.h"
#import "AssociatonRequestsViewController.h"



@implementation AssociationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [APPDELEGATE getUserAPIKEY];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
