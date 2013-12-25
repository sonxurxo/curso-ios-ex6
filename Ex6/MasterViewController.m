//
//  MasterViewController.m
//  Ex6
//
//  Created by Xurxo Méndez Pérez on 25/12/13.
//  Copyright (c) 2013 SmartGalApps. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "APIAccessor.h"
#import "User.h"

@interface MasterViewController ()
@end

@implementation MasterViewController {
    APIAccessor* _APIAccessor;
    
    NSArray* _users;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _APIAccessor = [APIAccessor sharedInstance];
    
    [_APIAccessor getAllUsersWithDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    User* user = _users[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.surname;
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        User* user = _users[indexPath.row];
        DetailViewController* detailViewController = segue.destinationViewController;
        detailViewController.user = user;
    }
}

#pragma mark - Get all users

- (void)getAllUsersSucceded:(NSArray*)users
{
    NSLog(@"getAllUsersSucceded");
    _users = users;
    [self.tableView reloadData];
}

- (void)getAllUsersFailed:(NSDictionary*)errorDictionary
{
    NSLog(@"getAllUsersFailed");
}

#pragma mark -

@end
