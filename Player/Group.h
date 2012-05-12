//
//  Friend.h
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject {

}
- (id)init;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* idNum;
@property (strong, nonatomic) NSMutableArray* friends;

@end
