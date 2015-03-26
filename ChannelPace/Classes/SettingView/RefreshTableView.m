//
//  RefreshTableView.m
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "RefreshTableView.h"
#import "AppDelegate.h"


@interface RefreshTableView ()

@end

@implementation RefreshTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshArray = [[NSArray alloc] init];
    refreshArray = @[@"Daily", @"Throughout the day", @"Manually"];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APPDELEGATE.userSettingObj.refreshTime = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [APPDELEGATE saveUserSetting];
    
    for (int i = 0; i < 3; i ++) {
        if (indexPath.row == i) {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    [tableView reloadData];
    
    


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", refreshArray[indexPath.row]];
    
    if ([APPDELEGATE.userSettingObj.refreshTime isEqual:@"Daily"]) {
        if ([cell.textLabel.text isEqual:@"Daily"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else if ([APPDELEGATE.userSettingObj.refreshTime isEqual:@"Throughout the day"]) {
        if ([cell.textLabel.text isEqual:@"Throughout the day"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if ([APPDELEGATE.userSettingObj.refreshTime isEqual:@"Manually"]) {
        if ([cell.textLabel.text isEqual:@"Manually"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    // Configure the cell...
    
    return cell;

}



- (IBAction)onBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
