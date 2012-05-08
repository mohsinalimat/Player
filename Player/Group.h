//
//  Friend.h
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject {
    NSString *name;
}
//Getting functions, return the info
- (NSString *)name;

- (id)init;

//These are the setters
- (void)setName:(NSString *)input;

@property (strong, nonatomic) NSString *groupName;

@end
