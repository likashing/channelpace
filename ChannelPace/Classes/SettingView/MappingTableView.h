//
//  MappingTableView.h
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MappingTableView : UITableViewController
{
    NSArray *mapArray;
}

@property (strong, nonatomic) IBOutlet UILabel *google;
@property (strong, nonatomic) IBOutlet UILabel *apple;



- (IBAction)onBackBtn:(id)sender;

@end
