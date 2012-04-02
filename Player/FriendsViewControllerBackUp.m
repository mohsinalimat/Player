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
#import "Friend.h"

@interface FriendsViewController() <ImportFriendsViewControllerDelegate, ContactsTableViewControllerDelegate>
@end

@implementation FriendsViewController

@synthesize scrollView;
@synthesize friends = _friends;

#define MY_FRIENDS @"FriendsViewController.MyFriends"

- (void)saveCustomObject:(NSMutableArray *)obj {
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:MY_FRIENDS];
    [defaults synchronize];
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    NSMutableArray *objs = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return objs;
}

- (void) syncFriendsWithDefaults
{
    [self saveCustomObject:friends];
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
            //PersonViewController *pvc = (PersonViewController*) segue.destinationViewController;
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
    friends = [self loadCustomObjectWithKey:MY_FRIENDS];
    if (!friends) friends = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString *r = [friends objectAtIndex:fromIndexPath.row]; 
    [friends removeObjectAtIndex:fromIndexPath.row];    
    [friends insertObject:r atIndex:toIndexPath.row];
}

-(void)refreshFriends:(NSNotification *) notification
{
    NSMutableArray *newlyAdded;
    newlyAdded = notification.object;
    
    [friends addObjectsFromArray:newlyAdded];
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
    NSObject *obj = [friends objectAtIndex:indexPath.row];
    NSString *idToDelete = [obj valueForKey:@"idNum"];
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        for (Friend *friend in friends)
        {
            if(idToDelete == friend.idNum)
            {
                [self.tableView beginUpdates];
                [friends removeObject:friend];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                [self.tableView endUpdates];
                break;
            }
        }
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
    
    NSObject *obj = [friends objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"name"];
    
    UIImage *imageData = [obj valueForKey:@"imageData"];
    NSString *imageURL = [obj valueForKey:@"imageURL"];
    if (imageData)
    {
        [cell.imageView setImage:imageData];
    }else if (imageURL)
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL]
                       placeholderImage:[UIImage imageNamed:@"spinner.png"]];
    }
    
    cell.showsReorderControl = YES;
    
    return cell;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
