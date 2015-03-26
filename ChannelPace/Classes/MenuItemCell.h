//
//  MenuItemCell.h
//  ChannelPace
//
//  Created by Eagle on 11/30/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelMenu;

- (void) setTableCell: (NSString *) text;


@end
