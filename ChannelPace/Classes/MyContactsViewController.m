//
//  MyContactsViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "MyContactsViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "AccountTableViewCell.h"
#import "ContactCardViewController.h"
#import "AccountInfo.h"
#import "SWRevealViewController.h"
#import "LoginSuccessfulViewController.h"
#import "AsyncImageView.h"
#import "OfflineViewController.h"
#import "NSString+md5.h"



@interface MyContactsViewController ()

{
    IBOutlet UITableView             *plainTableView;
    IBOutlet AIMTableViewIndexBar    *indexBar;
    IBOutlet UIButton                *toggleBtn;
    NSMutableArray                   *sections;
    NSMutableArray                   *rows;
    NSArray                          *searchResults;
    BOOL                             bSearch;
    BOOL                             bFirstNameSearch;
    BOOL                             _reloading;
    
    int                              keySrokeCount;
   
}
@end



@implementation MyContactsViewController

static MyContactsViewController *sharedData = nil;

+ (MyContactsViewController *) SharedData
{
    if (!sharedData) {
        sharedData = [[MyContactsViewController alloc] init];
    }
    return sharedData;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [APPDELEGATE getUserSetting];
    NSLog(@"SortName1 : %@", APPDELEGATE.userSettingObj.sortName);
    indexBar.delegate = self;
    _refreshHeaderView.delegate = self;
   
    [APPDELEGATE getUserAPIKEY];
    [self initVariable];
    [self initPullRefresh];
    
    rows = [[NSMutableArray alloc] init];
    
    for (char ch = 'A'; ch <= 'Z'; ch++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [rows addObject:array];
    }
    
    [self sortListFunction];
    
    [self customSetup];
    

}

- (void) initVariable
{
    
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.scopeBarBackgroundImage = [UIImage new];
    _searchBar.delegate = self;
    
    _dbhandler = [[DBHandler alloc] init];
    
    keySrokeCount = 0;
}

- (void) initPullRefresh
{
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - plainTableView.bounds.size.height, self.view.frame.size.width, plainTableView.bounds.size.height)];
        view.delegate = self;
        [plainTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) sortListFunction
{
    
    NSString *strKeyword = _searchBar.text;
    
    if ([APPDELEGATE.userSettingObj.sortName isEqualToString:@"FirstName"]) {
        bFirstNameSearch = YES;
    } else {
        bFirstNameSearch = NO;
    }
    
    if (sections)
        [sections removeAllObjects];
    else
        sections = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < rows.count; i++)
    {
        NSMutableArray *array = [rows objectAtIndex:i];
        [array removeAllObjects];
    }
    
    int i = 0;
    for (char ch = 'A'; ch <= 'Z'; ch++)
    {
        NSMutableArray *array = [rows objectAtIndex:i];
        [_dbhandler searchMyContactsListByCharacter:array keyword:[NSString stringWithFormat:@"%c", ch] type:bFirstNameSearch keyvalue:strKeyword];
        if ([array count] < 1)
            continue;
        i++;
        [sections addObject:[NSString stringWithFormat:@"%c", ch]];
    }
    
    [plainTableView reloadData];

}

- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [toggleBtn addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [revealViewController panGestureRecognizer];
        [revealViewController tapGestureRecognizer];
    }
}

#pragma mark -
#pragma mark Server Call Process

- (void) OnRequestMyContactsInfo
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    NSString *strMethod = @"contacts";
    NSString *strID = @"1";
    
    NSLog(@"user_apiKey : %@", APPDELEGATE.user_API_key);
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0",
                          @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method",
                          strID, @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
}

- (void) searchRequest: (NSString *) searchText
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    NSString *strMethod = @"search";
    NSString *strID = @"1";
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method", [NSArray arrayWithObjects: searchText, nil], @"params", strID, @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
        
}

- (void) OnReceived: (NSDictionary*) dictData {
    
    NSLog(@"%@", dictData);
    
    if (!bSearch) {
        //[self getAccountInfo:dictData];
        [[LoginSuccessfulViewController SharedData] getAccountInfo:dictData];
        
         _dbhandler = [[DBHandler alloc] init];
        [_dbhandler insertMyContactsList: APPDELEGATE.accountInfoArray];
        
        [self sortListFunction];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];

    } else {
        bSearch = false;
        NSLog(@"%@", dictData);
        
        /// pgc Add Insert,
    }
    
}

- (void) OnConnectFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Server connnection error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 123;
    [alert show];
    
}

- (void) OnOffline
{
    OfflineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        if (buttonIndex == 0) { // means share button pressed
            // write your code here to do whatever you want to do once the share button is pressed
        }
    }
    
}


- (NSString *) getNotNullValue:(NSObject *) param
{
    if (param == [NSNull null])
    {
        return @"";
    }
    
    return (NSString *)param;
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    [self OnRequestMyContactsInfo];         // PGC
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark Data Source Loading / Reloading Methods

- (void) reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    
    _reloading = YES;
    
}

- (void) doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:plainTableView];
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}





- (IBAction)processTabAction:(id)sender
{
    [_searchBar resignFirstResponder];
}



////////////////////////////

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //NSLog(@"%@", sections);
    return sections;
}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    for (int i = 0; i < [sections count]; i++) {
        if ([[sections objectAtIndex:i] isEqualToString:title]) {
            if (i == 0) {
                return -1;
            }
            else {
                return i;
            }
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    APPDELEGATE.accountInfoArray = [rows objectAtIndex:indexPath.section];
    APPDELEGATE.sourceAccount = [APPDELEGATE.accountInfoArray objectAtIndex:indexPath.row];
    APPDELEGATE.selectCellIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"gotoDetail" sender:self];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    [indexBar setIndexes:sections]; // to always have exact number of sections in table and indexBar
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [sections count];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSMutableArray *array = [rows objectAtIndex:section];
    
    return [array count];
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return sections[section];
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"TableViewCellId";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    //cell.accountImage.image = [UIImage imageNamed:@"no_photo_loggedin.png"];

    
    if (rows.count <= indexPath.section)
        return cell;
    
    NSMutableArray *resultArray = [rows objectAtIndex:indexPath.section];
    
    AccountInfo *info = [resultArray objectAtIndex:indexPath.row];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        info = [searchResults objectAtIndex:indexPath.row];
    }

    cell.accountImage.imageWithPath = nil;
    if (info.user_online == 1) {
        cell.accountImage.image = [UIImage imageNamed:@"no_photo_loggedin.png"];
    } else {
        cell.accountImage.image = [UIImage imageNamed:@"no_photo_neverloggedin.png"];
    }
    
    if ([APPDELEGATE.userSettingObj.orderName  isEqual: @"LastName FirstName"]) {
        cell.firstName.text = [NSString stringWithFormat:@"%@,  %@", info.strSurName, info.strFirstName];
        
    } else {
        cell.firstName.text = [NSString stringWithFormat:@"%@  %@", info.strFirstName, info.strSurName];
        
    }
   
    cell.labelJobTitle.text = info.strJobTitle;
    cell.labelDepartment.text = info.strReallyCompanyName;
    
    [cell.accountImage setImageWithPath:info.strPhotoURL];
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
        
}


#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    NSLog(@"rows[array] = %@", rows[index]);
    
    NSArray *arr = [rows objectAtIndex:index];
    if (!arr || [arr count] < 1)
        return;
    
    if ([plainTableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [plainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        NSIndexPath *indexPath = nil;
        AccountInfo *info = nil;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            info = [searchResults objectAtIndex:indexPath.row];
        }
        
    }
}


#pragma mark SearchBar Process

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self sortListFunction];
    [plainTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 4)
    {
        bSearch = true;
        [self searchRequest: searchText];
    }
    
    [self sortListFunction];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    keySrokeCount = 0;
    
}// called when text starts editing


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{

}

#pragma mark dealloc;

- (void)viewDidUnload {
    
    [self setSearchBar:nil];
    _refreshHeaderView=nil;
}

- (void)dealloc {
    
    _refreshHeaderView = nil;
    [super dealloc];
}










@end
