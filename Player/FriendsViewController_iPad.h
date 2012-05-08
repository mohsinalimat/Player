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

@interface FriendsViewController_iPad : UIViewController
{
    NSMutableArray *friends;
    NSMutableArray *groups;
    UIImageView *backgroundImageView;
    
    NewGroupPopOverViewController *_colorPicker;
    UIPopoverController *_colorPickerPopover;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)tapOnEdit:(id)sender;
- (IBAction)tapOnCreateNew:(id)sender;

@property (assign) NSMutableArray *friends;
@property (nonatomic,retain) NSMutableArray *groups;

@property (nonatomic, retain) NewGroupPopOverViewController *colorPicker;
@property (nonatomic, retain) UIPopoverController *colorPickerPopover;


@end
