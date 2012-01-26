//
//  PersonViewController.m
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonViewController.h"

@implementation PersonViewController

- (void) viewDidLoad
{
    personController = [[ABPersonViewController alloc] init];
    
    [personController setPersonViewDelegate:self];
    [personController setAllowsEditing:NO];
    personController.addressBook = ABAddressBookCreate();   
    
    personController.displayedProperties = [NSArray arrayWithObjects:
                                            [NSNumber numberWithInt:kABPersonPhoneProperty], 
                                            nil];
    
    [self setView:personController.view];
}

- (void) viewDidUnload
{
    
}

- (void) displayContactInfo: (ABRecordRef)person
{
    [personController setDisplayedPerson:person];
}

- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    // This is where you pass the selected contact property elsewhere in your program
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    return NO;
}

@end
