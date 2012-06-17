//
//  GridViewController.h
//  Player
//
//  Created by Sina on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRGridViewController.h"

@interface GridViewController : NRGridViewController
{
    int numberOfCells;
}

- (IBAction)createNewGroupTap:(id)sender;
- (IBAction)editButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;

@end
