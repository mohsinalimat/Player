//
//  Friend.m
//  Player
//
//  Created by Sina on 1/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Friend.h"
@implementation Friend
- (id)init {
    if (self = [super init]) {
        [self setName:@"Player Name"];
        [self setIdNum:@"idNum"];
        [self setGroup:@"Group"];
        [self setImageURL:@"imageURL"];
        [self setImageURL_iPad:@"imageURL_iPad"];
        [self setImageData:NULL];
    }
    return self;
}

- (NSString *)name {
    return name;
}

- (NSString *)idNum {
    return idNum ;
}

- (NSString *)group {
    return group ;
}

- (NSString *)imageURL {
    return imageURL ;
}

- (NSString *)imageURL_iPad {
    return imageURL_iPad ;
}

- (UIImage *)imageData {
    return imageData ;
}

- (void)setName:(NSString *)input {
    name = input;
}

- (void)setIdNum:(NSString *)input {
    idNum = input;
}

- (void)setGroup:(NSString *)input{
    group = input;
}

- (void)setImageURL:(NSString *)input {
    imageURL = input;
}

- (void)setImageURL_iPad:(NSString *)input {
    imageURL_iPad = input;
}

- (void)setImageData:(UIImage *)input {
    imageData = input;
}

/* This code has been added to support encoding and decoding my objecst */

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.idNum forKey:@"idNum"];
    [encoder encodeObject:self.group forKey:@"group"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    [encoder encodeObject:self.imageURL_iPad forKey:@"imageURL_iPad"];
    [encoder encodeObject:self.imageData forKey:@"imageData"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.idNum = [decoder decodeObjectForKey:@"idNum"];
        self.group = [decoder decodeObjectForKey:@"group"];
        self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
        self.imageURL_iPad = [decoder decodeObjectForKey:@"imageURL_iPad"];
        self.imageData = [decoder decodeObjectForKey:@"imageData"];
    }
    return self;
}

-(void)dealloc {

}
@end