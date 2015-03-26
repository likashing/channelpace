//
//  AssociatonRequestsViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "AssociatonRequestsViewController.h"
#import "AssociationTableViewCell.h"
#import "SWRevealViewController.h"
#import "OfflineViewController.h"
#import "LoginSuccessfulViewController.h"



@interface AssociatonRequestsViewController () 


@end

@implementation AssociatonRequestsViewController

@synthesize tableView;

static AssociatonRequestsViewController *sharedData = nil;

+ (AssociatonRequestsViewController *) SharedData
{
    if (!sharedData) {
        sharedData = [[AssociatonRequestsViewController alloc] init];
    }
    return sharedData;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rows = [[NSMutableArray alloc] init];
    
    [self initRequestFlag];
    
    [APPDELEGATE getUserAPIKEY];
    
    [self customSetup];
    
    [self OnRequest];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnOffline) name:@"offlineupdate" object:nil];
}

- (void) initRequestFlag
{
    _bAssociate = false;
    _bApprove = false;
    _bDelete = false;
}

- (void) OnRequest
{
    
    _bAssociate = true;
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    NSString *strMethod = @"getassoc";
    NSString *strID = @"1";
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method", strID, @"id", nil];
    
    NSLog(@"api key = %@", APPDELEGATE.user_API_key);
    NSLog(@"Associate Data:%@", dict);
    

    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url: APPDELEGATE.url];
    
    
}


- (void) getAssociationInfo: (NSDictionary *) dict
{
    
    NSArray *array = [dict objectForKey:@"result"];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dictItem = [array objectAtIndex:i];
        if (![dictItem objectForKey:@"full_name"]) {
            continue;
        }
        AccountInfo *info = [[AccountInfo alloc] init];
        info.mail_id = [[dictItem objectForKey:@"mail_id"] integerValue];
        info.userID = [[dictItem objectForKey:@"user_id"] integerValue];
        info.strFirstName = [dictItem objectForKey:@"user_name_f"];
        info.strSurName = [dictItem objectForKey:@"user_name_l"];
        info.strJobTitle = [dictItem objectForKey:@"user_job_position"];
        info.strCompanyName = [dictItem objectForKey:@"comp_name"];
        
        
        [rows addObject:info];
        
        APPDELEGATE.accountInfoObj = info;
        [APPDELEGATE.accountInfoArray addObject:info];
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark Table DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"AssociationTableViewCell";
    AssociationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[AssociationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    AccountInfo *info = [rows objectAtIndex:indexPath.row];
    
    cell.lastName.text = [NSString stringWithFormat:@"%@  %@", info.strFirstName, info.strSurName];
    
    cell.labelJobTitle.text = info.strJobTitle;
    cell.labelCompanyName.text = info.strCompanyName;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIButton *appbtn = cell.approveBtn;
    UIButton *delbtn = cell.deleteBtn;
    
    delbtn.frame = CGRectMake(cell.frame.origin.x + 230, cell.frame.origin.y + 20, 30, 30);
    appbtn.frame = CGRectMake(cell.frame.origin.x + 270, cell.frame.origin.y + 20, 30, 30);
    [delbtn setImage:[UIImage imageNamed:@"delete_btn"]forState:UIControlStateNormal];
    [appbtn setImage:[UIImage imageNamed:@"approve_btn"]forState:UIControlStateNormal];
    
    [cell.contentView addSubview:delbtn];
    [cell.contentView addSubview:appbtn];
    
    cell.approveBtn.tag = indexPath.row;
    [cell.approveBtn addTarget:self action:@selector(onApproveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void) onApproveClicked:(UIButton* )sender
{
    _bApprove = true;
    
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    int _assoc_action = 1;
    
    NSString *strMethod = [NSString stringWithFormat:@"procassoc"];
    
    NSArray *aryParam = [NSArray arrayWithObjects:[NSNumber numberWithInteger:APPDELEGATE.accountInfoObj.mail_id], [NSNumber numberWithInt:_assoc_action], nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method", aryParam, @"params", @"1", @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];

}

- (void) onDeleteClicked:(UIButton *)sender
{
    _bDelete = true;
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    NSString *strMethod = [NSString stringWithFormat:@"procassoc"];
    int _assoc_action = 0;
    
    NSArray *aryParam = [NSArray arrayWithObjects:[NSNumber numberWithInteger:APPDELEGATE.accountInfoObj.mail_id], [NSNumber numberWithInt:_assoc_action], nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method", aryParam, @"params", @"1", @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];

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


#pragma mark ServerCallDelegate

- (void) OnReceived: (NSDictionary*) dictData {
    
    //NSLog(@"%@", dictData);
    
    
    if (_bAssociate) {
        [self getAssociationInfo:dictData];
    } else if (_bApprove) {
        [rows removeObjectAtIndex:_index];

        [self OnRequest];
    } else if (_bDelete) {
        [rows removeObjectAtIndex:_index];

        [self OnRequest];
    }
    
    [tableView reloadData];
    
    [self initRequestFlag];
}

- (void) OnConnectFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Server connnection error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 345;
    [alert show];
    
    [self initRequestFlag];
}

- (void) OnOffline
{
    
    OfflineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineViewController"];
    
    [self.navigationController pushViewController:view animated:YES];
    
    [self initRequestFlag];
}





@end
