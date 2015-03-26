//
//  OnShareViewController.h
//  ChannelPace
//
//  Created by Eagle on 12/2/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DBHandler.h"
#import "AIMTableViewIndexBar.h"

@interface OnShareViewController : UIViewController<ServerCallDelegate, AIMTableViewIndexBarDelegate, UITableViewDataSource,
UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


@property (nonatomic, strong) DBHandler      *dbhandler;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


- (IBAction)onCancelBtn:(id)sender;

- (void) getAccountInfo:(NSDictionary *) dictData;


@end
