//
//  ContactsTableViewController.m
//  Player
//
//  Created by Sina on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "Friend.h"
#import "FriendUtility.h"

@implementation ContactsTableViewController

@synthesize chosenPeople = _chosenPeople;
@synthesize createUsingPhoneContacts = _createUsingPhoneContacts;
@synthesize createWithArray = _createWithArray;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onDone:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriends" object:_chosenPeople];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setCreateWithArray:(NSArray *)facebookFriends
{
    self.tableView.allowsMultipleSelection = YES;
    
    arrayOfCharacters = [[NSMutableArray alloc]init];
    _chosenPeople = [[NSMutableArray alloc]init];
    objectsForCharacters = [[NSMutableDictionary alloc]init];
    
    for(char c='A';c<='Z';c++)
    {
        NSMutableArray *arrayOfNames = [[NSMutableArray alloc] init];
        
        for(NSMutableDictionary *obj2 in facebookFriends)
        {
            NSString *objName = [obj2 objectForKey:@"name"];
            NSString *imageURL = [obj2 objectForKey:@"picture"];
             
            char char1 = [objName characterAtIndex:0];
            if(char1 == c)
            {
                [obj2 setValue:imageURL forKey:@"imageURL"];
                [arrayOfNames addObject:obj2];
            }
        }
        
        if([arrayOfNames count] > 0)
        {
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" 
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray = [arrayOfNames sortedArrayUsingDescriptors:sortDescriptors];
            
            [arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
            [objectsForCharacters setObject:sortedArray forKey:[NSString stringWithFormat:@"%c",c]];
        }
    }   
    
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView setNeedsDisplay];
}

- (void)setCreateUsingPhoneContacts:(NSString *)message
{
    self.tableView.allowsMultipleSelection = YES;
    
    addressBook = ABAddressBookCreate();
    nPeople = ABAddressBookGetPersonCount(addressBook);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);  
    
    arrayOfCharacters = [[NSMutableArray alloc]init];
    _chosenPeople = [[NSMutableArray alloc]init];
    objectsForCharacters = [[NSMutableDictionary alloc]init];
    
    for(char c='A';c<='Z';c++)
    {
        NSMutableArray *arrayOfNames = [[NSMutableArray alloc]init];
        
        for(int i = 0; i < CFArrayGetCount(allPeople); i++)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            NSNumber *myID = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
            
            NSString *firstNameAndSpace = [firstName stringByAppendingString:@" "];
            NSString *fullName = firstNameAndSpace;
            if(lastName) fullName = [firstNameAndSpace stringByAppendingString:lastName];
            
            char char1 = [fullName characterAtIndex:0];
            if(char1 == c)
            {
                NSMutableDictionary *obj2 = [[NSMutableDictionary alloc] init];
                
                if(ABPersonHasImageData(person))
                {
                    UIImage *image = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail)];
                    [obj2 setValue:image forKey:@"imageData"];
                }
                [obj2 setValue:fullName forKey:@"name"];
                [obj2 setValue:myID forKey:@"id"];
                
                [arrayOfNames addObject:obj2];
            }
        }
        
        if([arrayOfNames count] > 0)
        {
            [arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
            [objectsForCharacters setObject:arrayOfNames forKey:[NSString stringWithFormat:@"%c",c]];
        }
    }
    
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [arrayOfCharacters count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return arrayOfCharacters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
    for(NSString *character in arrayOfCharacters)
    {
        if([character isEqualToString:title])
            return count;
        count ++;
    }
    return 0; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([arrayOfCharacters count]==0)
        return @"";
    return [arrayOfCharacters objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"My cool cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    NSObject *obj = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [obj valueForKey:@"name"];
    
    UIImage *imageData = [obj valueForKey:@"imageData"];
    NSString *imageURL = [obj valueForKey:@"imageURL"];
    if (imageData)
    {
        [cell.imageView setImage:imageData];
    }else
    {
        if(imageURL)
        {
            [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL]
                           placeholderImage:[UIImage imageNamed:@"spinner.png"]];
        }else
        {
            cell.imageView.image = NULL;
        }
    }
    
    return cell;
}

- (void) addPerson:(Friend*)friend
{    
    [_chosenPeople addObject:friend];
}

- (void) removePerson:(Friend*)friend
{
    [_chosenPeople removeObject:friend];
}

- (Friend*) createFriendFromCell:(NSObject*)cell
{
    Friend *friend = [[Friend alloc] init];
    friend.name = [cell valueForKey:@"name"];
    friend.idNum = [cell valueForKey:@"id"];
    friend.imageURL = [cell valueForKey:@"picture"];
    friend.imageData = [cell valueForKey:@"imageData"];
    friend.relationshipStatus = [cell valueForKey:@"relationship_status"];
    friend.phoneNumber = [cell valueForKey:@"phoneNumber"];
    friend.email = [cell valueForKey:@"email"];
    
    NSString *imageURL = @"https://graph.facebook.com/";
    imageURL = [imageURL stringByAppendingString:[cell valueForKey:@"id"]];
    imageURL = [imageURL stringByAppendingString:@"/picture?type=large"];
    friend.imageURL_iPad = imageURL;
    
    return friend;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *s = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self addPerson:[self createFriendFromCell:s]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSObject *s = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self removePerson:[self createFriendFromCell:s]];
}
@end
