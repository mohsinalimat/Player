//
//  GMTableView.h
//  Player
//
//  Created by Sina on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface GMCell : UITableViewCell

- (void)setData:(NSMutableArray*)data;

@property (strong,nonatomic) GMGridView *gmGridView;
@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) NSMutableArray *currentData;

@end
