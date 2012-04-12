//
//  FriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController_iPad.h"
#import "ContactsTableViewController.h"
#import "PersonViewController.h"
#import "Friend.h"

#import "HorizontalTableView_iPad.h"
#import "ControlVariables.h"

#import "GMCell.h"
#import "GroupCell.h"

@implementation FriendsViewController_iPad

@synthesize editButton;
@synthesize friends = _friends;
@synthesize groups = _groups;

@synthesize myCell = _myCell;

@synthesize articleDictionary = _articleDictionary;
@synthesize reusableCells = _reusableCells;
@synthesize groupCells = _groupCells;
@synthesize backgroundImageView = _backgroundImageView;

#define MY_FRIENDS @"FriendsViewController.MyFriends"
#define kHeadlineSectionHeight  34
#define kRegularSectionHeight   24

-(NSMutableArray*)groups
{
    NSLog(@"Groups 1: %@", _groups);
    if (!_groups) _groups = [NSMutableArray array];
    
    [_groups addObject:@"Tonight"];
    [_groups addObject:@"Next Week"];
    [_groups addObject:@"Next Month"];
    [_groups addObject:@"Failed..."];
    
    NSLog(@"Groups 2: %@", _groups);
    
    return _groups;
}

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"To Person View"])
    {
        if ([segue.destinationViewController isKindOfClass:[PersonViewController class]])
        {
            //PersonViewController *pvc = (PersonViewController*) segue.destinationViewController;
            //[pvc displayContactInfo:person];
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

- (void)recreateCells
{
    /*
     NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
     NSArray* sortedCategories = [self.articleDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
     */
    
    //NSString *categoryName;
    NSMutableArray *currentCategory;
    
    self.reusableCells = [NSMutableArray array];
    self.groupCells = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++)
    {
        //HorizontalTableView_iPad *cell = [[HorizontalTableView_iPad alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        //categoryName = @"Tonight";//[sortedCategories objectAtIndex:i];
        currentCategory = friends;//[friends objectForKey:categoryName];
        //cell.articles = [NSArray arrayWithArray:currentCategory];
        
        GMCell *cell = [[GMCell alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        [cell setData:currentCategory];
    
        self.myCell = [cell gmGridView];
        [self.reusableCells addObject:cell];
        
        
        GroupCell *groupCell = [[GroupCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        [self.groupCells addObject:groupCell];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    friends = [self loadCustomObjectWithKey:MY_FRIENDS];
    if (!friends) friends = [NSMutableArray array];
    
    [self.groups addObject:@"Tonight"];
    [self.groups addObject:@"Next Week"];
    [self.groups addObject:@"Next Month"];
    [self.groups addObject:@"Failed..."];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriend:) name:@"deleteFriend" object:nil];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(60, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookshelf_empty.png"]];
    self.tableView.backgroundView = self.backgroundImageView;    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.editing = YES;
    
    [self recreateCells];
}

-(void)refreshFriends:(NSNotification *) notification
{
    NSMutableArray *newlyAdded;
    newlyAdded = notification.object;
    
    [friends addObjectsFromArray:newlyAdded];
    [self syncFriendsWithDefaults];
    [self recreateCells];
    [self.tableView reloadData];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)tapOnEdit:(id)sender
{
    for (int i = 0; i < [self.groupCells count]; i++)
    {
        GroupCell * cell = [self.groupCells objectAtIndex:i];
        [cell sina];
    }
    /*
    if(editButton.title == @"Done")
    {
        for (int i = 0; i < [self.reusableCells count]; i++)
        {
            GMCell * cell = [self.reusableCells objectAtIndex:i];
            cell.editing = NO;
        }
        editButton.title = @"Edit";
    }else {
        for (int i = 0; i < [self.reusableCells count]; i++)
        {
            GMCell * cell = [self.reusableCells objectAtIndex:i];
            cell.editing = YES;
        }
        editButton.title = @"Done";
    }
     */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.reusableCells count] == 0)
        return 0;
    else
        return ([self.reusableCells count]*2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.reusableCells count] == 0)
        return 0;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = indexPath.section;
    if (num % 2 == 0)
    {
        return 30;
    }else {
        return kCellHeight_iPad + 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = indexPath.section;
    if (num % 2 == 0)
    {
        GroupCell *cell = [self.groupCells objectAtIndex:indexPath.section/2];
        return cell;
    }else {
        GMCell *cell = [self.reusableCells objectAtIndex:indexPath.section/2];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    //return section == 0 ? kHeadlineSectionHeight : kRegularSectionHeight;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customSectionHeaderView;
    UILabel *titleLabel;
    UIFont *labelFont;
    
    if (section == 0)
    {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kHeadlineSectionHeight)];
        labelFont = [UIFont boldSystemFontOfSize:20];
    }
    else
    {
        customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kRegularSectionHeight)];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, kRegularSectionHeight)];
        
        labelFont = [UIFont boldSystemFontOfSize:13];
    }
    
    customSectionHeaderView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.0];
    
    titleLabel.textAlignment = UITextAlignmentLeft;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];   
    titleLabel.font = labelFont;
    
    //NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    //NSArray* sortedCategories = [self.articleDictionary.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSString *categoryName = @"Tonight";//[sortedCategories objectAtIndex:section];
    
    titleLabel.text = categoryName;
    
    [customSectionHeaderView addSubview:titleLabel];
    
    return customSectionHeaderView;
}
 */

- (void)viewDidUnload {
    [self setEditButton:nil];
    [super viewDidUnload];
}
@end
