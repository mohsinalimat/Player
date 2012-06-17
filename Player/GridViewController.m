//
//  MyGridViewController.m
//  NRGridViewSampleApp
//
//  Created by Louka Desroziers on 04/02/12.
//  Copyright (c) 2012 Novedia Regions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "GridViewController.h"
#import "FriendsManager.h"

#define MY_GROUPS @"FriendsViewController.MyGroups"

@interface GridViewController () <UITextFieldDelegate>

@property (nonatomic, strong) FriendsManager *friendsManager;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *specialViews;
@property (nonatomic) BOOL editing;

@end

static BOOL const _kNRGridViewSampleCrazyScrollEnabled = NO; // For the lulz.
@implementation GridViewController

@synthesize friendsManager = _friendsManager;
@synthesize groups = _groups;
@synthesize specialViews = _specialViews;
@synthesize editBarButton = _editBarButton;
@synthesize editing = _editing;

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

-(BOOL)editing
{
    return _editing;
}

-(void) setEditing:(BOOL)editing
{
    _editing = editing;
    
    if(_editing)
    {
        [self.editBarButton setTitle:@"Done"];
    }else {
        [self.editBarButton setTitle:@"Edit"];
    }
    
    for(UIView* view in self.specialViews)
    {
        view.hidden = !_editing;
    }
}


#pragma mark - Crazy Scroll LULZ
- (void)__beginGeneratingCrazyScrolls
{
    if(_kNRGridViewSampleCrazyScrollEnabled==NO)return;
    
    NSInteger randomSection = arc4random() % ([[[self gridView] dataSource] respondsToSelector:@selector(numberOfSectionsInGridView:)]
                                              ? [[[self gridView] dataSource] numberOfSectionsInGridView:[self gridView]]
                                              : 1);
    NSInteger randomItemIndex = arc4random() % [[[self gridView] dataSource] gridView:[self gridView] 
                                                               numberOfItemsInSection:randomSection];
    
    
    [[self gridView] selectCellAtIndexPath:[NSIndexPath indexPathForItemIndex:randomItemIndex inSection:randomSection] 
                                autoScroll:YES 
                            scrollPosition:NRGridViewScrollPositionAtMiddle
                                  animated:YES];
    
    /*
     [[self gridView] scrollRectToSection:randomSection 
     animated:YES 
     scrollPosition:NRGridViewScrollPositionAtBottom];
     */
    
    [self performSelector:@selector(__beginGeneratingCrazyScrolls) 
               withObject:nil 
               afterDelay:2.5 
                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

- (void)__endGeneratingCrazyScrolls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                             selector:@selector(__beginGeneratingCrazyScrolls) 
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self __beginGeneratingCrazyScrolls];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self __endGeneratingCrazyScrolls];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
}

- (IBAction)createNewGroupTap:(id)sender {
    [self performSegueWithIdentifier:@"ToCreateNewGroup" sender:self];
}

- (IBAction)editButtonTapped:(id)sender {
    [self setEditing:!_editing];
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self = [super initWithGridLayoutStyle:NRGridViewLayoutStyleVertical];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [super initWithGridLayoutStyle:NRGridViewLayoutStyleVertical];
    }
    return self;
}

#pragma mark - View lifecycle
- (BOOL)canBecomeFirstResponder{return YES;}

- (void)loadView
{ 
    [super loadView];
    
    [[self gridView] setCellSize:CGSizeMake(80, 100)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
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
    [self.gridView reloadData];
}

#pragma mark - NRGridView Data Source
- (NSInteger)numberOfSectionsInGridView:(NRGridView *)gridView
{
    return [self.groups count];
}

- (NSInteger)gridView:(NRGridView *)gridView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = [self.friendsManager getFriendsForGroup:section];
    return [array count];
}

- (NSString*)gridView:(NRGridView *)gridView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %i", section];
}

- (CGFloat)gridView:(NRGridView*)gridView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*)gridView:(NRGridView*)gridView viewForHeaderInSection:(NSInteger)section
{
    UIColor *blue = [UIColor colorWithRed:0 green:.8 blue:1 alpha:1];
    UIColor *white = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [headerView setBackgroundColor:white];
    
    Group *group = [self.groups objectAtIndex:section];
    
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
    [deleteButton setFrame:CGRectMake(self.view.bounds.size.width - 30, 5, 25, 25)];
    [deleteButton addTarget:self action:@selector(deleteGroupTap:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:deleteButton];
    deleteButton.tag = section;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(self.view.bounds.size.width - 60, 5, 25, 25)];
    [addButton addTarget:self action:@selector(addFriendsTap:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    addButton.tag = section;
    
    if(!self.editing)
    {
        addButton.hidden = YES;
        deleteButton.hidden = YES;
    }
    
    [self.specialViews addObject:addButton];
    [self.specialViews addObject:deleteButton];
    
    return headerView;
}

-(void)addFriendsTap:(UIView*)sender
{
    [self.friendsManager setCurrentGroup:sender.tag];
    [self performSegueWithIdentifier:@"ToAddFriends" sender:self];
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
        [self.gridView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.friendsManager updateGroup:textField.tag toName:textField.text];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.gridView reloadData];
}

- (NRGridViewCell*)gridView:(NRGridView *)gridView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyCellIdentifier = @"MyCellIdentifier";
    
    NRGridViewCell* cell = [gridView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    
    if(cell == nil){
        cell = [[NRGridViewCell alloc] initWithReuseIdentifier:MyCellIdentifier];
        
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:11.]];
        [[cell detailedTextLabel] setFont:[UIFont systemFontOfSize:11.]];
    }
    
    NSArray *array = [self.friendsManager getFriendsForGroup:indexPath.section];
    Friend *friend = [array objectAtIndex:indexPath.row];

    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7,0,56,56)];
    //imageView.layer.cornerRadius = 10;
    //imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:imageView];
    
    NSString *imageURL = [friend imageURL];
    [imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"spinner.png"]];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,60,70,20)];
    textLabel.textAlignment = UITextAlignmentCenter;
    [textLabel setBackgroundColor:[UIColor clearColor]];
    textLabel.text = friend.name;
    [textLabel setFont:[UIFont fontWithName:@"Optima" size:12]];
    [cell.contentView addSubview:textLabel];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(-15, -15, 40, 40)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"close_x.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteFriendTap:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteButton];
    deleteButton.tag = indexPath.row;
    cell.contentView.tag = indexPath.section;
    
    if(!self.editing)
    {
        deleteButton.hidden = YES;
    }
    
    [self.specialViews addObject:deleteButton];
    
    return cell;
}

-(void)deleteFriendTap:(UIButton*)button
{
    [self.friendsManager removeFriendAtRow:button.tag inSection:button.superview.tag];
    [self setGroups:[self.friendsManager getObjectsForKey:MY_GROUPS]];
    [self.gridView reloadData];
}

#pragma mark - NRGridView Delegate

- (void)gridView:(NRGridView *)gridView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.friendsManager setCurrentGroup:indexPath.section];
    [self.friendsManager setCurrentFriend:indexPath.row];
    [self performSegueWithIdentifier:@"ToPerson" sender:self];
}

- (void)gridView:(NRGridView *)gridView didLongPressCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController* menuController = [UIMenuController sharedMenuController];
    NRGridViewCell* cell = [gridView cellAtIndexPath:indexPath];
    
    [self becomeFirstResponder];
    [menuController setMenuItems:[NSArray arrayWithObject:[[UIMenuItem alloc] initWithTitle:@"Hooorayyyy!" 
                                                                                      action:@selector(handleHooray:)]]];
    [menuController setTargetRect:[cell frame] 
                           inView:[self view]];
    
    [menuController setMenuVisible:YES animated:YES];
    
}

#pragma mark - UIMenuController Actions

- (void)handleHooray:(id)sender
{
    [[self gridView] unhighlightPressuredCellAnimated:YES];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(handleHooray:));
}

#pragma mark - Memory Management


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
