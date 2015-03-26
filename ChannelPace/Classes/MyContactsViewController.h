//
//  MyContactsViewController.h
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DBHandler.h"
#import "AIMTableViewIndexBar.h"
#import "EGORefreshTableHeaderView.h"



@interface MyContactsViewController : UIViewController<ServerCallDelegate, AIMTableViewIndexBarDelegate, UITableViewDataSource,
UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) DBHandler      *dbhandler;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;


+ (MyContactsViewController *) SharedData;

- (void) getAccountInfo:(NSDictionary *) dictData;
- (void) OnRequestMyContactsInfo;

- (void) refreshTable;
- (NSString *) categoryNameAtIndexPath: (NSIndexPath *)path;
- (int) countFirstLettersInArray:(NSArray *)categoryArray;
- (NSArray *) itemsInSection: (NSInteger)section;
- (NSString *) firstLetter: (NSInteger) section;
- (IBAction) processTabAction:(id)sender;

- (void) searchRequest: (NSString *) searchText;
- (void) reloadTableViewDataSource;
- (void) doneLoadingTableViewData;


@end
