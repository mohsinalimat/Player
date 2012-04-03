//
//  Friend.h
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject {
    NSString *name;
    NSString *idNum;
    NSString *group;
    NSString *imageURL;
    NSString *imageURL_iPad;
    UIImage *imageData;
}
//Getting functions, return the info
- (NSString *)name;
- (NSString *)idNum;
- (NSString *)group;
- (NSString *)imageURL;
- (NSString *)imageURL_iPad;
- (UIImage *)imageData;

- (id)init;

//These are the setters
- (void)setName:(NSString *)input;
- (void)setIdNum:(NSString *)input;
- (void)setGroup:(NSString *)input;
- (void)setImageURL:(NSString *)input;
- (void)setImageURL_iPad:(NSString *)input;
- (void)setImageData:(UIImage *)input;

@end
