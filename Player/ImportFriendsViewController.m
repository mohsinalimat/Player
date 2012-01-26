//
//  ImportFriendsViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportFriendsViewController.h"
#import "ContactsTableViewController.h"

@interface ImportFriendsViewController()
@end

@implementation ImportFriendsViewController

@synthesize delegate = _delegate;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"To iPhone Contacts"])
    {
        [self.delegate importFriendsViewController:self setMyPhoneContactsView:segue.destinationViewController];
        
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

@end
