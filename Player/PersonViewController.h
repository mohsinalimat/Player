//
//  PersonViewController.h
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@class PersonViewController;

@interface PersonViewController : UIViewController <ABPersonViewControllerDelegate> 
{
    ABPersonViewController *personController;
}

- (void) displayContactInfo: (ABRecordRef)person;

@end