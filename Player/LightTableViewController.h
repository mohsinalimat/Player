//
//  LightTableViewController.h
//  Player
//
//  Created by Sina on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightTableViewController : UITableViewController
- (IBAction)createNewGroupTap:(id)sender;
- (IBAction)editButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;

@end
