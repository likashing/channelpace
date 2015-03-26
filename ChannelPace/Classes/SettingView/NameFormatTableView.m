//
//  NameFormatTableView.m
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "NameFormatTableView.h"
#import "AppDelegate.h"



@interface NameFormatTableView ()

@end

@implementation NameFormatTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameArray = [[NSArray alloc] init];
    nameArray = @[@"FirstName LastName", @"LastName FirstName"];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////===================////////////////////////
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
    APPDELEGATE.userSettingObj.orderName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", nameArray[indexPath.row]];
    
    if ([APPDELEGATE.userSettingObj.orderName isEqual:@"FirstName LastName"]) {
        if ([cell.textLabel.text isEqual:@"FirstName LastName"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else if ([APPDELEGATE.userSettingObj.orderName isEqual:@"LastName FirstName"]) {
        if ([cell.textLabel.text isEqual:@"LastName FirstName"]) {
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
