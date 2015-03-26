//
//  MappingTableView.m
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "MappingTableView.h"
#import "AppDelegate.h"



@interface MappingTableView ()

@end

@implementation MappingTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapArray = [[NSArray alloc] init];
    mapArray = @[@"Google", @"Apple"];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//////////////////////////=======================///////////////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APPDELEGATE.userSettingObj.mapping = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [APPDELEGATE saveUserSetting];
    
    for (int i = 0; i < 2; i ++) {
        if (indexPath.row == i) {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", mapArray[indexPath.row]];
    
    if ([APPDELEGATE.userSettingObj.mapping isEqual:@"Google"]) {
        if ([cell.textLabel.text isEqual:@"Google"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else if ([APPDELEGATE.userSettingObj.mapping isEqual:@"Apple"]) {
        if ([cell.textLabel.text isEqual:@"Apple"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    // Configure the cell...
    
    return cell;

}




@end
