//
//  ImportFriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportFriendsViewController.h"
#import "ContactsTableViewController.h"
#import "Friend.h"
#import "FriendUtility.h"

@implementation ImportFriendsViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"To iPhone Contacts"])
    {
        if ([segue.destinationViewController isKindOfClass:[ContactsTableViewController class]])
        {
            [(ContactsTableViewController *)segue.destinationViewController setCreateUsingPhoneContacts:@"Sina"];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if(person)
    {
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSNumber *myID = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
        
        NSString *firstNameAndSpace = [firstName stringByAppendingString:@" "];
        NSString *fullName = firstNameAndSpace;
        if(lastName) fullName = [firstNameAndSpace stringByAppendingString:lastName];
        
        Friend *friend = [[Friend alloc] init];
        friend.name = fullName;
        friend.idNum = [NSString stringWithFormat:@"%d", myID];
        if(ABPersonHasImageData(person))
        {
            UIImage *imageData = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail)];
            friend.imageData = imageData;
        }

        NSMutableArray *array = [NSMutableArray arrayWithObjects:friend, nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriends" object:array];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES]; -- Go to back to Home
}

- (IBAction)onCreateNewPerson:(id)sender {
    ABNewPersonViewController *personView = [[ABNewPersonViewController alloc] init];
    personView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    personView.newPersonViewDelegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:personView];
    [self presentModalViewController:nc animated:YES];
}

@end


