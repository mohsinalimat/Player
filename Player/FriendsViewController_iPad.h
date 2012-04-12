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

@interface FriendsViewController_iPad : UITableViewController <UITableViewDelegate>
{
    NSMutableArray *friends;
    NSMutableArray *groups;
    NSDictionary *_articleDictionary;
    NSMutableArray *_reusableCells;
    NSMutableArray *_groupCells;
    UIImageView *backgroundImageView;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)tapOnEdit:(id)sender;

@property (assign) NSMutableArray *friends;
@property (nonatomic,retain) NSMutableArray *groups;

@property (nonatomic, retain) GMGridView *myCell;

@property (nonatomic, retain) NSDictionary *articleDictionary;
@property (nonatomic, retain) NSMutableArray *reusableCells;
@property (nonatomic, retain) NSMutableArray *groupCells;
@property (nonatomic, retain) UIImageView *backgroundImageView;



@end
