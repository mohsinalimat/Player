//
//  FriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "GroupsGridViewController.h"
#import "ContactsTableViewController.h"
#import "PersonViewController.h"
#import "Friend.h"
#import "Group.h"
#import "NewGroupPopOverViewController.h"
#import "FriendsManager.h"

#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 

#define MY_FRIENDS @"FriendsViewController.MyFriends"
#define MY_GROUPS @"FriendsViewController.MyGroups"

@interface GroupsGridViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate, NewGroupPopOverDelegate, UITextFieldDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSInteger _lastDeleteItemIndexAsked;
}

@property (nonatomic, strong) FriendsManager *friendsManager;

@end

@implementation GroupsGridViewController
@synthesize gridHolder = _gridHolder;
@synthesize editButton;

@synthesize friends = _friends;
@synthesize groups = _groups;

@synthesize colorPicker = _colorPicker;
@synthesize colorPickerPopover = _colorPickerPopover;
@synthesize popUpView = _popUpView;
@synthesize groupNameTextField = _groupNameTextField;
@synthesize friendsManager = _friendsManager;

- (FriendsManager *)friendsManager
{
    if (!_friendsManager) _friendsManager = [FriendsManager sharedManager];
    return _friendsManager;
}

-(void)createGroupWithName:(NSString *)name
{
    [self.friendsManager createGroupWithName:name];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [_gmGridView reloadData];
    
    [self.colorPickerPopover dismissPopoverAnimated:YES];
}

- (IBAction)tapOnCreateNew:(id)sender 
{
    if(INTERFACE_IS_PAD)
    {
        if (_colorPicker == nil) {
            self.colorPicker = [[NewGroupPopOverViewController alloc] init];
            _colorPicker.delegate = self;
            self.colorPickerPopover = [[UIPopoverController alloc] initWithContentViewController:_colorPicker];
        }
        [self.colorPickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else if(INTERFACE_IS_PHONE){
        self.groupNameTextField.text = @"";
        self.popUpView.hidden = NO;
        [self.groupNameTextField endEditing:NO];
    }
}

- (IBAction)onDoneCreating:(id)sender {
    if(![self.groupNameTextField.text isEqualToString:@""])
    {
        [self.friendsManager createGroupWithName:self.groupNameTextField.text];
        [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
        [_gmGridView reloadData];
        self.popUpView.hidden = YES;
        
        [self.groupNameTextField endEditing:YES];
    }
}

-(void)setGroups:(NSMutableArray *)input
{
    _groups = input;
}

-(NSMutableArray*)groups
{
    /*
    if(!_groups)
        _groups = [self.friendsManager getObjectsForKey:MY_GROUPS];
    return [self.friendsManager getObjectsForKey:MY_GROUPS];
     */
    
    if(!_groups)
        _groups = [NSMutableArray array];
    return _groups;
}

- (void) syncFriendsWithDefaults
{
    //[self.friendsManager saveObjects:friends forKey:MY_FRIENDS];
    [self.friendsManager saveObjects:self.groups forKey:MY_GROUPS];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"To Person View"])
    {
        if ([segue.destinationViewController isKindOfClass:[PersonViewController class]])
        {
            //PersonViewController *pvc = (PersonViewController*) segue.destinationViewController;
            //[pvc displayContactInfo:person];
        }
    }else if ([segue.identifier isEqualToString:@"To a Group"]){ 
        
        UIViewController *fgvc = (UIViewController*) segue.destinationViewController;
        fgvc.navigationItem.title = self.friendsManager.currentGroupName;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [_gmGridView reloadData];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriend:) name:@"deleteFriend" object:nil];
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 10 : 30;
    
    GMGridView *gmGridView;
    
    if(INTERFACE_IS_PAD)
    {
        gmGridView = [[GMGridView alloc] initWithFrame:
                      CGRectMake(32, 80, self.view.bounds.size.width-64, self.view.bounds.size.height-500)];
    }else if(INTERFACE_IS_PHONE)
    {
        gmGridView = [[GMGridView alloc] initWithFrame:
                      CGRectMake(10, 20, 300, 380)];
    }
    
    //GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.gridHolder addSubview:gmGridView];
    
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStylePush;
    _gmGridView.pagingEnabled = YES;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    if(INTERFACE_IS_PHONE)
    {
        self.popUpView.hidden = YES;
        self.popUpView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
        self.groupNameTextField.delegate = self;
    }
    
    [self recreateCells];
}

- (void)recreateCells
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)setEditing:(BOOL)editing
{
    [super setEditing:!self.editing];
    _gmGridView.editing = editing;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // width will be 768, which divides by four nicely already
        //NSLog( @"Setting left+right content insets to zero" );
    }
    else
    {
        // width will be 1024, so subtract a little to get a width divisible by five
        //NSLog( @"Setting left+right content insets to 2.0" );
    }
}

-(void)refreshFriends:(NSNotification *) notification
{
    NSMutableArray *newlyAdded;
    newlyAdded = notification.object;
    
    for(int i=0; i < [newlyAdded count]; i++)
    {
        Friend *friend = [newlyAdded objectAtIndex:i];
        //[friend setGroup:self.friendsManager.currentGroup];
        [self.friendsManager addFriend:friend toGroup:@"EMPTY"];
        //[friends insertObject:friend atIndex:0];
    }
    
    //[self syncFriendsWithDefaults];
    //[self recreateCells];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [_gmGridView reloadData];
}

-(void)deleteFriend:(NSNotification *) notification
{
    Friend *friendToDelete = (Friend *)notification.object;
    for (int i = 0; i < [friends count]; i++) {
        Friend *friend = [friends objectAtIndex:i];
        if(friend.idNum == friendToDelete.idNum)
        {
            [friends removeObjectAtIndex:i];
            [self syncFriendsWithDefaults];
            break;
        }
    }
}

- (IBAction)tapOnEdit:(id)sender
{
    if(editButton.titleLabel.text == @"Done")
    {
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        _gmGridView.editing = NO;
    }else if (editButton.titleLabel.text = @"Edit"){
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        _gmGridView.editing = YES;
    }
}

- (void)viewDidUnload {
    [self setEditButton:nil];
    [self setEditButton:nil];
    [self setPopUpView:nil];
    [self setGroupNameTextField:nil];
    [self setGridHolder:nil];
    [super viewDidUnload];
}

//////////////////////////////////////////////////////////////
#pragma mark orientation management
//////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.groups count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) 
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(60, 80);
        }
        else
        {
            return CGSizeMake(60, 80);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(100, 120);
        }
        else
        {
            return CGSizeMake(100, 120);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    Group *group = [self.groups objectAtIndex:index];
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *image = [UIImage imageNamed:@"bg.jpg"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height-20)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    imageView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height-20, size.width, 20)];
    //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    label.text = group.name;
    
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.highlightedTextColor = [UIColor whiteColor];
    if (INTERFACE_IS_PHONE)
        label.font = [UIFont boldSystemFontOfSize:10];
    else
        label.font = [UIFont boldSystemFontOfSize:14];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 2);
    [cell.contentView addSubview:label];
    
    UILabel *numOfFriends = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-20)];
    //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    numOfFriends.text = [NSString stringWithFormat:@"%i", [group.friends count]];
    
    numOfFriends.textAlignment = UITextAlignmentCenter;
    numOfFriends.backgroundColor = [UIColor clearColor];
    numOfFriends.textColor = [UIColor whiteColor];
    numOfFriends.highlightedTextColor = [UIColor whiteColor];
    if (INTERFACE_IS_PHONE)
        numOfFriends.font = [UIFont boldSystemFontOfSize:20];
    else
        numOfFriends.font = [UIFont boldSystemFontOfSize:40];
    numOfFriends.shadowColor = [UIColor blackColor];
    numOfFriends.shadowOffset = CGSizeMake(1, 2);
    [cell.contentView addSubview:numOfFriends];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    [self.friendsManager setCurrentGroup:position];
    [self performSegueWithIdentifier:@"To a Group" sender:self];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
        [self.friendsManager removeGroup:_lastDeleteItemIndexAsked];
        [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{  
                         cell.contentView.backgroundColor = [UIColor clearColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    [self.friendsManager rearrangeGroupsFrom:oldIndex to:newIndex];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [friends exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) 
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(320, 210);
        }
        else
        {
            return CGSizeMake(300, 310);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(700, 530);
        }
        else
        {
            return CGSizeMake(600, 500);
        }
    }
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (INTERFACE_IS_PHONE) 
    {
        label.font = [UIFont boldSystemFontOfSize:15];
    }
    else
    {
        label.font = [UIFont boldSystemFontOfSize:20];
    }
    
    [fullView addSubview:label];
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor clearColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}

@end
