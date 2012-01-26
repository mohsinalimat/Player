//
//  ContactsTableViewController.m
//  Player
//
//  Created by Sina on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsTableViewController.h"

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
    
    //[self.delegate contactsTableViewController:self doneAdding:_chosenPeople];
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
             
            char char1 = [objName characterAtIndex:0];
            if(char1 == c)
            {
                UIImage *buttonImage = [UIImage imageNamed:@"thumb_girl.png"];
                [obj2 setValue:buttonImage forKey:@"image"];
                
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
            
            NSString *firstNameAndSpace = [firstName stringByAppendingString:@" "];
            NSString *fullName = firstNameAndSpace;
            if(lastName) fullName = [firstNameAndSpace stringByAppendingString:lastName];
            
            char char1 = [fullName characterAtIndex:0];
            if(char1 == c)
            {
                NSMutableDictionary *obj2 = [[NSMutableDictionary alloc] init];
                UIImage *buttonImage = [UIImage imageNamed:@"thumb_girl.png"];
                
                [obj2 setValue:buttonImage forKey:@"image"];
                [obj2 setValue:fullName forKey:@"name"];
                
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
    
    //UIImage *image = [UIImage imageNamed:@"thumb_girl.png"];
    UIImage *image = [obj valueForKey:@"image"];
    cell.imageView.image = image;

    return cell;
}

- (void) addPerson:(NSString*)person
{
    [_chosenPeople addObject:person];
}

- (void) removePerson:(NSString*)person
{
    [_chosenPeople removeObject:person];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *s = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self addPerson:s];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *s = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self removePerson:s];
}
@end