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
        [self setRelationshipStatus:@"Mystery!"];
        [self setPhoneNumber:@"Mystery!"];
        [self setEmail:@"Mystery!"];
    }
    return self;
}

@synthesize name = _name;
@synthesize idNum = _idNum;
@synthesize group = _group;
@synthesize imageURL = _imageURL;
@synthesize imageURL_iPad = _imageURL_iPad;
@synthesize imageData = _imageData;
@synthesize relationshipStatus = _relationshipStatus;
@synthesize phoneNumber = _phoneNumber;
@synthesize email = _email;
@synthesize rating = _rating;

- (NSString *)name {
    return _name;
}

- (NSString *)idNum {
    return _idNum ;
}

- (NSString *)group {
    return _group ;
}

- (NSString *)imageURL {
    return _imageURL ;
}

- (NSString *)imageURL_iPad {
    return _imageURL_iPad ;
}

- (UIImage *)imageData {
    return _imageData ;
}

- (NSString *)relationshipStatus {
    if(!_relationshipStatus || _relationshipStatus == @"")
        _relationshipStatus = @"Not Available";
    return _relationshipStatus ;
}

- (NSString *)phoneNumber {
    if(!_phoneNumber || _phoneNumber == @"")
        _phoneNumber = @"000-000-0000";
    return _phoneNumber ;
}

- (NSString *)email {
    if(!_email || _email == @"")
        _email = @"name@domain.com";
    return _email ;
}

- (NSNumber *)rating {
    if(!_rating)
        _rating = [NSNumber numberWithInt:7];
    return _rating;
}

- (void)setName:(NSString *)input {
    _name = input;
}

- (void)setIdNum:(NSString *)input {
    _idNum = input;
}

- (void)setGroup:(NSString *)input{
    _group = input;
}

- (void)setImageURL:(NSString *)input {
    _imageURL = input;
}

- (void)setImageURL_iPad:(NSString *)input {
    _imageURL_iPad = input;
}

- (void)setImageData:(UIImage *)input {
    _imageData = input;
}

- (void)setRelationshipStatus:(NSString *)input{
    _relationshipStatus = input;
}

- (void)setPhoneNumber:(NSString *)input{
    _phoneNumber = input;
}

- (void)setEmail:(NSString *)input{
    _email = input;
}

- (void)setRating:(NSNumber *)input{
    _rating = input;
}

/* This code has been added to support encoding and decoding my objects */

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.idNum forKey:@"idNum"];
    [encoder encodeObject:self.group forKey:@"group"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    [encoder encodeObject:self.imageURL_iPad forKey:@"imageURL_iPad"];
    [encoder encodeObject:self.imageData forKey:@"imageData"];
    [encoder encodeObject:self.relationshipStatus forKey:@"relationshipStatus"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.rating forKey:@"rating"];
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
        self.relationshipStatus = [decoder decodeObjectForKey:@"relationshipStatus"];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.rating = [decoder decodeObjectForKey:@"rating"];
    }
    return self;
}

-(void)dealloc {

}
@end