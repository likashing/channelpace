//
//  SortTableView.m
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "SortTableView.h"
#import "AppDelegate.h"
#import "SelectCell.h"


@interface SortTableView ()

@end

@implementation SortTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameArray = [[NSArray alloc] init];
    nameArray = @[@"FirstName", @"LastName"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//////////////////===================////////////////////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SortCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", nameArray[indexPath.row]];
    
    if ([APPDELEGATE.userSettingObj.sortName isEqual:@"FirstName"]) {
        if ([cell.textLabel.text isEqual:@"FirstName"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }       
        
    } else if ([APPDELEGATE.userSettingObj.sortName isEqual:@"LastName"]) {
        if ([cell.textLabel.text isEqual:@"LastName"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    APPDELEGATE.userSettingObj.sortName =[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [APPDELEGATE saveUserSetting];
    
    for (int i = 0; i < 2; i ++) {
        if (indexPath.row == i) {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
        }else
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryNone;
    }
    
    [tableView reloadData];
    
}


- (IBAction)onBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
