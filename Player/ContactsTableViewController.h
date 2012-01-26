//
//  ContactsTableViewController.h
//  Player
//
//  Created by Sina on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@class ContactsTableViewController;

@protocol ContactsTableViewControllerDelegate
@optional
- (void) contactsTableViewController:(ContactsTableViewController *)sender
                          doneAdding:(NSMutableArray *)people;
@end

@interface ContactsTableViewController : UITableViewController
{
    ABAddressBookRef addressBook;
    CFIndex nPeople;
    CFArrayRef allPeople;
    NSMutableArray *arrayOfCharacters;
    NSMutableDictionary *objectsForCharacters;
}

@property (nonatomic, strong) NSMutableArray *chosenPeople;
@property (nonatomic, strong) NSArray *createWithArray;
@property (nonatomic, strong) NSString *createUsingPhoneContacts;
@property (nonatomic, weak) id <ContactsTableViewControllerDelegate> delegate;

- (IBAction)onDone:(id)sender;

@end
