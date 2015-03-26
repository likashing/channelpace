//
//  OnShareViewController.m
//  ChannelPace
//
//  Created by Eagle on 12/2/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "OnShareViewController.h"
#import "AppDelegate.h"
#import "LoginSuccessfulViewController.h"
#import "OnShareTableViewCell.h"
#import "OfflineViewController.h"


@interface OnShareViewController ()

{
    IBOutlet UITableView             *plainTableView;
    IBOutlet AIMTableViewIndexBar    *indexBar;
    IBOutlet UIButton                *cancelBtn;
    NSMutableArray                   *sections;
    NSMutableArray                   *rows;
    
    NSArray                          *searchResults;
    BOOL                             bFirstNameSearch;
    
}
@end



@implementation OnShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchBar.backgroundImage = [UIImage new];
    _searchBar.scopeBarBackgroundImage = [UIImage new];
    _searchBar.delegate = self;
    indexBar.delegate = self;
    
    rows = [[NSMutableArray alloc] init];
    
    for (char ch = 'A'; ch <= 'Z'; ch++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [rows addObject:array];
    }

    _dbhandler = [[DBHandler alloc] init];
    
    //[APPDELEGATE getLoginInfo];
    //[APPDELEGATE getUserSetting];
    [APPDELEGATE getUserAPIKEY];
    
    [self sortListFunction];    
    
    [plainTableView reloadData];
    
    
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


- (void) viewDidUnload {
    
    [self setSearchBar:nil];

    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

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
    AccountInfo *info = [[AccountInfo alloc] init];
    APPDELEGATE.accountInfoArray = [rows objectAtIndex:indexPath.section];
    APPDELEGATE.targetAccount = [APPDELEGATE.accountInfoArray objectAtIndex:indexPath.row];
    info = APPDELEGATE.targetAccount;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Share." message:[NSString stringWithFormat:@"Share contact with %@ \n at %@?", info.strFirstName, info.strReallyCompanyName]  delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    alert.tag = 111;
    [alert show];
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
    OnShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[OnShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    
    if (rows.count <= indexPath.section)
        return cell;
    
    NSMutableArray *resultArray = [rows objectAtIndex:indexPath.section];
    
    AccountInfo *info = [resultArray objectAtIndex:indexPath.row];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        info = [searchResults objectAtIndex:indexPath.row];
    }
    
    if (info.user_online == 1) {
        cell.accountImage.image = [UIImage imageNamed:@"no_photo_loggedin.png"];
    } else {
        cell.accountImage.image = [UIImage imageNamed:@"no_photo_neverloggedin.png"];
    }
    
    if ([APPDELEGATE.userSettingObj.orderName  isEqual: @"LastName FirstName"]) {
        cell.fName.text = [NSString stringWithFormat:@"%@,  %@", info.strSurName, info.strFirstName];
        
    } else {
        cell.fName.text = [NSString stringWithFormat:@"%@  %@", info.strFirstName, info.strSurName];
        
    }
    
    cell.company.text = info.strReallyCompanyName;
    cell.jobTitle.text = info.strJobTitle;
    
    [cell.accountImage setImageWithPath:info.strPhotoURL];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
   
    NSArray *arr = [rows objectAtIndex:index];
    if (!arr || [arr count] < 1) {
        return;
    }
    if ([plainTableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [plainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}


///////////////////////=================/////////////////////

#pragma mark Alert Process

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            [self OnRequest];
            
        } else if (buttonIndex == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
 
    }
    
    if (alertView.tag == 123) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    
    
}


/////////////////////////======================////////////////////
#pragma mark ServerCall Process

- (void) OnRequest
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    NSString *strMethod = @"share";
        
    NSArray *paramArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:APPDELEGATE.sourceAccount.userID], [NSNumber numberWithInteger:APPDELEGATE.targetAccount.userID], nil];
    
    NSString *strID = @"1";
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0",
                          @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method", paramArray, @"params",
                          strID, @"id", nil];
    NSLog(@"MyDetail Data : %@", dict);
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
}

- (void) OnReceived: (NSDictionary*) dictData {
    
    NSLog(@"%@", dictData);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Completed." message:@"Your PaceShare has been completed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void) OnConnectFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Server connnection error." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 123;
    [alert show];
    
}

- (void) OnOffline
{
    OfflineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
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
    [self sortListFunction];
}









@end
