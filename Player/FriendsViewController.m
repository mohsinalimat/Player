//
//  FriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"
#import "ImportFriendsViewController.h"
#import "ContactsTableViewController.h"
#import "PersonViewController.h"

@interface FriendsViewController() <ImportFriendsViewControllerDelegate, ContactsTableViewControllerDelegate>
@end

@implementation FriendsViewController

@synthesize friends = _friends;

#define MY_FRIENDS @"FriendsViewController.MyFriends"

- (void) syncFriendsWithDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:friends forKey:MY_FRIENDS];
    [defaults synchronize];
}

- (void) contactsTableViewController:(ContactsTableViewController *)sender 
                          doneAdding:(NSMutableArray *)people
{
    [friends addObjectsFromArray:people];
    [self syncFriendsWithDefaults];
    [self.tableView reloadData];
}

- (void) importFriendsViewController:(ImportFriendsViewController *)sender 
              setMyPhoneContactsView:(ContactsTableViewController *)myPhoneContactsView
{
    [myPhoneContactsView setDelegate:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"To Import Friends"])
    {
        [segue.destinationViewController setDelegate:self];
    }else if ([segue.identifier isEqualToString:@"To Person View"])
    {
        if ([segue.destinationViewController isKindOfClass:[PersonViewController class]])
        {
//            PersonViewController *pvc = (PersonViewController*) segue.destinationViewController;
            //[pvc displayContactInfo:person];
        }
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    friends = [[defaults objectForKey:MY_FRIENDS] mutableCopy];
    if (!friends) friends = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];;
}

-(void)refreshFriends:(NSNotification *) notification
{
    /*[label setText:@"Profile Pic Loaded..."];
     UIImageView *profilePicture = notification.object;
     [profilePicHolder addSubview:profilePicture];*/
    
    NSMutableArray *people;
    people = [[NSMutableArray alloc] init];
    people = notification.object;

    [friends addObjectsFromArray:people];
    [self syncFriendsWithDefaults];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - TableViewCells

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.tableView beginUpdates];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *name = cell.textLabel.text;
        [friends removeObject:name];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [self.tableView endUpdates];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing){

    }else{
        [self syncFriendsWithDefaults];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"My Friend Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [friends objectAtIndex:indexPath.row];
    
    UIImage *buttonImage = [UIImage imageNamed:@"thumb_girl.png"];
    cell.imageView.image = buttonImage;
    
    return cell;
}

@end
