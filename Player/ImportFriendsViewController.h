//
//  ImportFriendsViewController.h
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsTableViewController.h"

@interface ImportFriendsViewController : UIViewController <ABNewPersonViewControllerDelegate>

- (IBAction)onCreateNewPerson:(id)sender;
@end