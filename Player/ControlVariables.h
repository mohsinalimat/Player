//
//  Header.h
//  HorizontalTables
//
//  Created by Felipe Laso on 8/19/11.
//  Copyright 2011 Felipe Laso. All rights reserved.
//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// iPhone CONSTANTS
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Width (or length before rotation) of the table view embedded within another table view's row
#define kTableLength                                320

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth                                  78
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight                                 65

// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding            3
#define kArticleCellHorizontalInnerPadding          10

// Padding for the title label in an article's cell
#define kArticleTitleLabelPadding                   4

// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding                         0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding                       0

// The background color of the vertical table view
#define kVerticalTableBackgroundColor               [UIColor colorWithRed:0.58823529 green:0.58823529 blue:0.58823529 alpha:1.0]

// Background color for the horizontal table view (the one embedded inside the rows of our vertical table)
#define kHorizontalTableBackgroundColor             [UIColor colorWithRed:0.6745098 green:0.6745098 blue:0.6745098 alpha:1.0]

// The background color on the horizontal table view for when we select a particular cell
#define kHorizontalTableSelectedBackgroundColor     [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// iPad CONSTANTS
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Width (or length before rotation) of the table view embedded within another table view's row
#define kTableLength_iPad                               768

// Height for the Headlines section of the main (vertical) table view
#define kHeadlinesSectionHeight_iPad                    65

// Height for regular sections in the main table view
#define kRegularSectionHeight_iPad                      36

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth_iPad                                 128
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight_iPad                                130

// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding_iPad           4
#define kArticleCellHorizontalInnerPadding_iPad         4

// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding_iPad                        0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding_iPad                      0
