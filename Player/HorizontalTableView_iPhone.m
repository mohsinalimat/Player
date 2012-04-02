//
//  LineViewController.m
//  HorTest
//
//  Created by Sina on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HorizontalTableView_iPhone.h"
#import "ControlVariables.h"
#import "ArticleCell_iPhone.h"
#import "ArticleTitleLabel.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"

@implementation HorizontalTableView_iPhone

@synthesize horizontalTableView = _horizontalTableView;
@synthesize articles = _articles;

#pragma mark - View lifecycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        // do init stuff
    }
    
    self.horizontalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kTableLength)];
    self.horizontalTableView.pagingEnabled = YES;
    self.horizontalTableView.showsVerticalScrollIndicator = NO;
    self.horizontalTableView.showsHorizontalScrollIndicator = NO;
    self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    [self.horizontalTableView setFrame:CGRectMake(kRowHorizontalPadding * 0.5, kRowVerticalPadding * 0.5, kTableLength - kRowHorizontalPadding, kCellHeight)];
    
    self.horizontalTableView.rowHeight = kCellWidth;
    self.horizontalTableView.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:0];
    
    self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.horizontalTableView.separatorColor = [UIColor clearColor];
    
    self.horizontalTableView.dataSource = self;
    self.horizontalTableView.delegate = self;
    [self addSubview:self.horizontalTableView];
    
    return self;
}

- (NSString *) reuseIdentifier 
{
    return @"LineViewController";
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCell";
    
    __block ArticleCell_iPhone *cell = (ArticleCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[ArticleCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellHeight)];
    }
    
    __block Friend *friend = [self.articles objectAtIndex:indexPath.row];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{        
        UIImage *image = nil;        
        //image = [UIImage imageNamed:@"AppleMusic.png"];
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:friend.imageURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.thumbnail setImage:image]; 
        });
    });
    
    cell.titleLabel.text = friend.name;
    
    return cell;
}

@end