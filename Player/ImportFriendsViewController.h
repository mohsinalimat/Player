//
//  ImportFriendsViewController.h
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTableViewController.h"

@class ImportFriendsViewController;

@protocol ImportFriendsViewControllerDelegate
- (void) importFriendsViewController:(ImportFriendsViewController *)sender
                      setMyPhoneContactsView:(ContactsTableViewController *)myPhoneContactsView;
@end

@interface ImportFriendsViewController : UIViewController
@property (nonatomic, weak) id <ImportFriendsViewControllerDelegate> delegate;

@end
