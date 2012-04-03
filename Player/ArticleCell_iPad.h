//
//  ArticleCell_iPad.h
//  HorizontalTables
//
//  Created by Felipe Laso on 8/20/11.
//  Copyright 2011 Felipe Laso. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleTitleLabel;

@interface ArticleCell_iPad : UITableViewCell 
{
    UIImageView *_thumbnail;
    ArticleTitleLabel *_titleLabel;
}

@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) ArticleTitleLabel *titleLabel;

@end
