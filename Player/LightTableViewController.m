//
//  WhiteTableViewController.m
//  TableViewTest
//
//  Created by Sina on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LightTableViewController.h"
#import "UIImageView+WebCache.h"
#import "FriendsManager.h"
#import "Friend.h"

#define MY_FRIENDS @"FriendsViewController.MyFriends"
#define MY_GROUPS @"FriendsViewController.MyGroups"

#define HEADER_BUTTONS_HEIGHT 30
#define HEADER_BUTTONS_WIDTH 30

@interface LightTableViewController ()

@property (nonatomic, strong) FriendsManager *friendsManager;
@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation LightTableViewController

@synthesize friendsManager = _friendsManager;
@synthesize groups = _groups;

- (FriendsManager *)friendsManager
{
    if (!_friendsManager) _friendsManager = [FriendsManager sharedManager];
    return _friendsManager;
}

-(void)setGroups:(NSMutableArray *)input
{
    _groups = input;
}

-(NSMutableArray*)groups
{
    if(!_groups)
        _groups = [NSMutableArray array];
    return _groups;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    
    [self.tableView setEditing:YES];
    
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // create a toolbar where we can place some buttons
    UIToolbar* toolbar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, 0, 100, 45)];
    [toolbar setBarStyle: UIBarStyleBlackOpaque];
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a standard save button
    UIBarButtonItem *createGroupButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(createGroupAction:)];
    createGroupButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:createGroupButton];
    
    // put the buttons in the toolbar and release them
    [toolbar setItems:buttons animated:NO];
    
    toolbar.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithCustomView:toolbar];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    [self.tableView setNeedsLayout];
}

-(void)createGroupAction:(id)sender
{
    NSLog(@"createGroupAction");
    [self performSegueWithIdentifier:@"toCreateNewGroup" sender:self];
}

-(void)refreshFriends:(NSNotification *) notification
{
    NSMutableArray *newlyAdded;
    newlyAdded = notification.object;
    
    for(int i=0; i < [newlyAdded count]; i++)
    {
        Friend *friend = [newlyAdded objectAtIndex:i];
        [self.friendsManager addFriend:friend toGroup:@"EMPTY"];
    }
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.friendsManager getFriendsForGroup:section];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Title";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *array = [self.friendsManager getFriendsForGroup:indexPath.section];
    Friend *friend = [array objectAtIndex:indexPath.row];
    
    cell.textLabel.text = friend.name;
    cell.showsReorderControl = YES;
    cell.shouldIndentWhileEditing = NO;
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Optima" size:18]];
    cell.indentationWidth = 30;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,35,35)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:imageView];
    
    NSString *imageURL = [friend imageURL];
    
    [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"spinner.png"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //	Grip customization code goes in here...
    for(UIView* view in cell.subviews)
    {
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
        {
            UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
            [resizedGripView addSubview:view];
            [cell addSubview:resizedGripView];
            
            CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - view.frame.size.width, resizedGripView.frame.size.height - view.frame.size.height);
            CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / view.frame.size.width, resizedGripView.frame.size.height / view.frame.size.height);
            
            //	Original transform
            CGAffineTransform transform = CGAffineTransformIdentity;
            
            //	Scale custom view so grip will fill entire cell
            transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
            
            //	Move custom view so the grip's top left aligns with the cell's top left
            transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
            
            [resizedGripView setTransform:transform];
            
            for(UIImageView* cellGrip in view.subviews)
            {
                if([cellGrip isKindOfClass:[UIImageView class]])
                    [cellGrip setImage:nil];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    Group *group = [self.groups objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    headerView.tag = section;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 200, 20)];
    label.text = group.name;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithRed:0 green:.5 blue:1 alpha:1]];
    [label setFont:[UIFont fontWithName:@"Optima" size:30]];
    [headerView addSubview:label];
    
    UIButton *addFriendsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addFriendsButton setTitle:@"+" forState:UIControlStateNormal];
    [addFriendsButton addTarget:self action:@selector(addFriendsTap:) forControlEvents:UIControlEventTouchUpInside];
    [addFriendsButton setFrame:CGRectMake(tableView.bounds.size.width-HEADER_BUTTONS_WIDTH-10, 
                                          5, 
                                          HEADER_BUTTONS_WIDTH, 
                                          HEADER_BUTTONS_HEIGHT)];
    [headerView addSubview:addFriendsButton];
    
    UIButton *deleteGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteGroupButton setTitle:@"-" forState:UIControlStateNormal];
    [deleteGroupButton addTarget:self action:@selector(deleteGroupTap:) forControlEvents:UIControlEventTouchUpInside];
    [deleteGroupButton setFrame:CGRectMake(tableView.bounds.size.width-(2*HEADER_BUTTONS_WIDTH)-20, 
                                          5, 
                                          HEADER_BUTTONS_WIDTH, 
                                          HEADER_BUTTONS_HEIGHT)];
    [headerView addSubview:deleteGroupButton];
    
    return headerView;
}

-(void)addFriendsTap:(UIButton*)sender
{
    [self.friendsManager setCurrentGroup:sender.superview.tag];
    [self performSegueWithIdentifier:@"toAddFriends" sender:self];
}

-(void)deleteGroupTap:(UIButton*)sender
{
    [self.friendsManager setCurrentGroup:sender.superview.tag];
    
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to delete '%@%@", self.friendsManager.currentGroupName, @"' ?"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Fine delete");
    if (buttonIndex == 1) 
    {
        [self.friendsManager removeGroup:self.friendsManager.currentGroup];
        [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
        [self.tableView reloadData];
        [self.tableView setNeedsDisplay];
        [self.tableView setNeedsLayout];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.friendsManager moveFriendFrom:fromIndexPath to:toIndexPath];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tap");
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
