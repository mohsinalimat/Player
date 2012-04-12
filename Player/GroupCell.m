//
//  ViewController.m
//  GMGridView
//
//  Created by Gulam Moledina on 11-10-09.
//  Copyright (c) 2011 GMoledina.ca. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GroupCell.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "Friend.h"

@implementation GroupCell

- (id)init
{
    if ((self =[super init])) 
    {
        
    }
    return self;
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self != nil) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, frame.size.width, 30)];
        textField.text = @"Value";
        textField.textAlignment = UITextAlignmentLeft;
        textField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.1];
        textField.textColor = [UIColor whiteColor];
        textField.font = [UIFont boldSystemFontOfSize:20];
        
        [self addSubview:textField];
        
        UIImage *image = [UIImage imageNamed:@"bg.jpg"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
        imageView.image = image;
        self.showsReorderControl = YES;
    }
    
    return self;
}

-(void)sina
{
    for(UIView* view in self.subviews)
    {
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
        {
            UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
            [resizedGripView addSubview:view];
            [self addSubview:resizedGripView];
            
            CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - view.frame.size.width, resizedGripView.frame.size.height - view.frame.size.height);
            CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / view.frame.size.width, resizedGripView.frame.size.height / view.frame.size.height);
            
            //	Original transform
            CGAffineTransform transform = CGAffineTransformIdentity;
            
            //	Scale custom view so grip will fill entire cell
            transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
            
            //	Move custom view so the grip's top left aligns with the cell's top left
            transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
            
            [resizedGripView setTransform:transform];
            
            for(UIImageView* cellGrip in view.subviews)
			{
				if([cellGrip isKindOfClass:[UIImageView class]])
					[cellGrip setImage:nil];
			}
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}
@end
