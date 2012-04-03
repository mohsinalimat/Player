//
//  ArticleCell.m
//  HorizontalTables
//
//  Created by Felipe Laso on 8/20/11.
//  Copyright 2011 Felipe Laso. All rights reserved.
//

#import "ArticleCell_iPad.h"
#import "ArticleTitleLabel.h"
#import "ControlVariables.h"
#import <QuartzCore/QuartzCore.h>

@implementation ArticleCell_iPad

@synthesize thumbnail = _thumbnail;
@synthesize titleLabel = _titleLabel;

#pragma mark - View Lifecycle

- (NSString *)reuseIdentifier 
{
    return @"ArticleCell";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        // do init stuff
    }
    
    self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding_iPad, kArticleCellVerticalInnerPadding_iPad, kCellWidth_iPad - kArticleCellHorizontalInnerPadding_iPad * 2, kCellHeight_iPad - kArticleCellVerticalInnerPadding_iPad * 2)];
    self.thumbnail.opaque = YES;
    
    self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
    self.thumbnail.backgroundColor = [UIColor blackColor];
    
    self.thumbnail.layer.cornerRadius = 10.0;
    self.thumbnail.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.thumbnail];
    
    self.titleLabel = [[ArticleTitleLabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height * 0.8, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.2)];
    self.titleLabel.opaque = YES;
    [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9]];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    [self.thumbnail addSubview:self.titleLabel];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:0];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbnail.frame];
    self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);

    return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    self.thumbnail = nil;
    self.titleLabel = nil;
}

@end
