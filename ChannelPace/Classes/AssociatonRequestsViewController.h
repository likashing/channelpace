//
//  AssociatonRequestsViewController.h
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AssociatonRequestsViewController : UIViewController <ServerCallDelegate,
UITableViewDataSource,
UITableViewDelegate>

{
    IBOutlet UIButton *toggleBtn;
    NSMutableArray *rows;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property BOOL          bAssociate;
@property BOOL          bApprove;
@property BOOL          bDelete;

@property NSInteger     index;


+ (AssociatonRequestsViewController *) SharedData;

@end
