//
//  NameFormatTableView.h
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameFormatTableView : UITableViewController
{
    NSArray *nameArray;
}

@property (strong, nonatomic) IBOutlet UILabel *flMode;
@property (strong, nonatomic) IBOutlet UILabel *lfMode;


- (IBAction)onBackBtn:(id)sender;


@end
