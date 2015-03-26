//
//  SortTableView.h
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortTableView : UITableViewController
{
    NSArray *nameArray;
}


@property (strong, nonatomic) IBOutlet UILabel *firstname;
@property (strong, nonatomic) IBOutlet UILabel *lastname;


- (IBAction)onBackBtn:(id)sender;


@end
