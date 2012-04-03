//
//  FriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController_iPhone.h"
#import "ContactsTableViewController.h"
#import "PersonViewController.h"
#import "Friend.h"

#import "HorizontalTableView_iPhone.h"
#import "ControlVariables.h"

@implementation FriendsViewController_iPhone

@synthesize editButton;
@synthesize friends = _friends;

@synthesize articleDictionary = _articleDictionary;
@synthesize reusableCells = _reusableCells;
@synthesize backgroundImageView = _backgroundImageView;


#define MY_FRIENDS @"FriendsViewController.MyFriends"
#define kHeadlineSectionHeight  34
#define kRegularSectionHeight   24

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
    
    NSString *categoryName;
    NSArray *currentCategory;
    
    self.reusableCells = [NSMutableArray array];
    
    for (int i = 0; i < [friends count]; i++)
    {                        
        HorizontalTableView_iPhone *cell = [[HorizontalTableView_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        
        categoryName = @"Tonight";//[sortedCategories objectAtIndex:i];
        currentCategory = friends;//[friends objectForKey:categoryName];
        cell.articles = [NSArray arrayWithArray:currentCategory];
        
        [self.reusableCells addObject:cell];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    friends = [self loadCustomObjectWithKey:MY_FRIENDS];
    if (!friends) friends = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookshelf_empty.png"]];
    self.tableView.backgroundView = self.backgroundImageView;    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    
    self.tableView.scrollEnabled = NO;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)tapOnEdit:(id)sender
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.reusableCells count] == 0)
        return 0;
    else
        return 4;
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
    return kCellHeight + 11.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HorizontalTableView_iPhone *cell = [self.reusableCells objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    //return section == 0 ? kHeadlineSectionHeight : kRegularSectionHeight;
}

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

- (void)viewDidUnload {
    [self setEditButton:nil];
    [super viewDidUnload];
}
@end
