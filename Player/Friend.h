//
//  Friend.h
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject {
    
}

- (id)init;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* idNum;
@property (strong, nonatomic) NSString* group;
@property (strong, nonatomic) NSString* relationshipStatus;
@property (strong, nonatomic) NSString* phoneNumber;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* imageURL;
@property (strong, nonatomic) NSString* imageURL_iPad;
@property (strong, nonatomic) UIImage * imageData;
@property (strong, nonatomic) NSNumber* rating;

@end
