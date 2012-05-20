//
//  FriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "PersonViewController.h"
#import "Friend.h"
#import "FriendsManager.h"
#import "FriendsGridViewController.h"
#import "FriendViewController.h"

#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 

#define MY_FRIENDS @"FriendsViewController.MyFriends"
#define MY_GROUPS @"FriendsViewController.MyGroups"

@interface FriendsGridViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    NSInteger _lastDeleteItemIndexAsked;
    int indexSelected;
}

@property (nonatomic, strong) FriendsManager *friendsManager;

@end


@implementation FriendsGridViewController

@synthesize editButton;
@synthesize friends = _friends;
@synthesize friendsManager = _friendsManager;

- (FriendsManager *)friendsManager
{
    if (!_friendsManager) _friendsManager = [FriendsManager sharedManager];
    return _friendsManager;
}

- (void) syncFriendsWithDefaults
{
    //[self.friendsManager saveObjects:self.friends forKey:MY_FRIENDS];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"To Person"])
    {
        if ([segue.destinationViewController isKindOfClass:[FriendViewController class]])
        {
            Friend *friend = [self.friends objectAtIndex:indexSelected];
            FriendViewController *vc = (FriendViewController*) segue.destinationViewController;
            [vc displayFriendInfo:friend];
            vc.navigationItem.title = friend.name;
        }
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

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.friends = [self.friendsManager getFriendsForGroup:self.friendsManager.currentGroup];
    if (!self.friends) self.friends = [NSMutableArray array];
    
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
    [self.view addSubview:gmGridView];
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
    
    [self recreateCells];
}

- (void)recreateCells
{
    
}

- (IBAction)onTapEdit:(id)sender 
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

-(void)deleteFriend:(NSNotification *) notification
{
    Friend *friendToDelete = (Friend *)notification.object;
    for (int i = 0; i < [self.friends count]; i++) {
        Friend *friend = [self.friends objectAtIndex:i];
        if(friend.idNum == friendToDelete.idNum)
        {
            [self.friends removeObjectAtIndex:i];
            [self syncFriendsWithDefaults];
            break;
        }
    }
}

- (void)viewDidUnload {
    [self setEditButton:nil];
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
    return [self.friends count];
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
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
     Friend *friend = [self.friends objectAtIndex:index];
     
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height-20)];
     imageView.layer.masksToBounds = YES;
     imageView.layer.cornerRadius = 10;
     imageView.contentMode = UIViewContentModeScaleAspectFit;
     imageView.backgroundColor = [UIColor blackColor];
     [cell.contentView addSubview:imageView];
    
    NSString *imageURL = [friend imageURL_iPad];
    
    [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"spinner.png"]];
     
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height-20, size.width, 20)];
     //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     label.text = [friend name];
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
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    indexSelected = position;
    [self performSegueWithIdentifier:@"To Person" sender:self];
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
        [self.friendsManager removeFriend:[self.friends objectAtIndex:_lastDeleteItemIndexAsked]];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
        self.friends = [self.friendsManager getFriendsForGroup:self.friendsManager.currentGroup];
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
    [self.friendsManager rearrangeFriendsFrom:oldIndex to:newIndex];
     
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [self.friends exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
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
