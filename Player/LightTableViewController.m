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

@interface LightTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) FriendsManager *friendsManager;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *specialViews;

@end

@implementation LightTableViewController
@synthesize editBarButton = _editBarButton;

@synthesize friendsManager = _friendsManager;
@synthesize groups = _groups;
@synthesize specialViews = _specialViews;

-(NSMutableArray*)specialViews
{
    if(!_specialViews)
        _specialViews = [NSMutableArray array];
    return _specialViews;
}

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

- (void)viewDidUnload {
    [self setEditBarButton:nil];
    [super viewDidUnload];
}
- (IBAction)editButtonTapped:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    for(UIView* view in self.specialViews)
	{
        view.hidden = !self.tableView.editing;
    }
    
    if(!self.tableView.editing)
    {
        [self.editBarButton setTitle:@"Edit"];
    }else {
        [self.editBarButton setTitle:@"Done"];
    }
}

- (void)viewDidLoad
{
    NSLog(@"Did Load");
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    
    //[self.tableView setEditing:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    [self.tableView setNeedsLayout];
}

- (IBAction)createNewGroupTap:(id)sender {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIColor *blue = [UIColor colorWithRed:0 green:.8 blue:1 alpha:1];
    UIColor *white = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    Group *group = [self.groups objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:white];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    tf.tag = section;
    tf.delegate = self;
    tf.text = group.name;
    [tf setBackgroundColor:[UIColor clearColor]];
    [tf setTextColor:blue];
    [tf setFont:[UIFont fontWithName:@"Optima" size:20]];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.enablesReturnKeyAutomatically = YES;
    [headerView addSubview:tf];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"trash_icon.png"] forState:UIControlStateNormal];
    [deleteButton setFrame:CGRectMake(tableView.bounds.size.width - 30, 7, 25, 25)];
    [deleteButton addTarget:self action:@selector(deleteGroupTap:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:deleteButton];
    deleteButton.tag = section;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(tableView.bounds.size.width - 60, 7, 25, 25)];
    [addButton addTarget:self action:@selector(addFriendsTap:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    addButton.tag = section;
    
    if(!self.tableView.editing)
    {
        addButton.hidden = YES;
        deleteButton.hidden = YES;
    }
    
    [self.specialViews addObject:addButton];
    [self.specialViews addObject:deleteButton];
    
    return headerView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.friendsManager updateGroup:textField.tag toName:textField.text];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:textField.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *array = [self.friendsManager getFriendsForGroup:indexPath.section];
    Friend *friend = [array objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = friend.name;
    cell.showsReorderControl = YES;
    cell.shouldIndentWhileEditing = NO;
    //[cell.textLabel setFont:[UIFont fontWithName:@"Optima" size:18]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,5,35,35)];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:imageView];
    
    NSString *imageURL = [friend imageURL];
    [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"spinner.png"]];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,5,230,30)];
    textLabel.text = friend.name;
    [textLabel setFont:[UIFont fontWithName:@"Optima" size:18]];
    [cell.contentView addSubview:textLabel];
    
    return cell;
}

-(void)addFriendsTap:(UIView*)sender
{
    [self.friendsManager setCurrentGroup:sender.tag];
    [self performSegueWithIdentifier:@"toAddFriends" sender:self];
}

-(void)deleteGroupTap:(UIButton*)sender
{
    [self.friendsManager setCurrentGroup:sender.tag];
    
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to delete '%@%@", self.friendsManager.currentGroupName, @"' ?"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        [self.friendsManager removeGroup:self.friendsManager.currentGroup];
        [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.friendsManager.currentGroup] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.friendsManager removeFriendAtRow:indexPath.row inSection:indexPath.section];
        [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
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
    [self.friendsManager setCurrentGroup:indexPath.section];
    [self.friendsManager setCurrentFriend:indexPath.row];
    [self performSegueWithIdentifier:@"ToPerson" sender:self];
}

/*
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
                {
                    [cellGrip setImage:nil];
                }	
			}
            
            UITapGestureRecognizer *singleFingerTap = 
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            
            UISwipeGestureRecognizer *swipeGesture = 
            [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
            
            [view addGestureRecognizer:singleFingerTap];
            [view addGestureRecognizer:swipeGesture];
            view.tag = indexPath.row;
		}
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"tap");
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe");
    UITableViewCell *cell = (UITableViewCell*)recognizer.view.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.friendsManager removeFriendAtRow:indexPath.row inSection:indexPath.section];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.tableView reloadData];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}
*/

@end





