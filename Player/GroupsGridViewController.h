//
//  FriendsViewController_iPad.h
//  Player
//
//  Created by Sina on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "GMGridView.h"
#import "NewGroupPopOverViewController.h"

@interface GroupsGridViewController : UIViewController
{
    NSMutableArray *friends;
    NSMutableArray *groups;
    UIImageView *backgroundImageView;
}

- (IBAction)tapOnEdit:(id)sender;
- (IBAction)tapOnCreateNew:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (assign) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NewGroupPopOverViewController *colorPicker;
@property (nonatomic, strong) UIPopoverController *colorPickerPopover;


@end
