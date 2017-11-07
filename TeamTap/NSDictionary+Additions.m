//
//  NSDictionary+Additions.m
//  TeamTap
//
//  Created by Jason Cox on 26/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (id)objectForKeyNotNull:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null]) {
        return nil;
    }
    
    return object;
}

@end
