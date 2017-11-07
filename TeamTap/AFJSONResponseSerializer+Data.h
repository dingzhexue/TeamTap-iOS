//
//  AFJSONResponseSerializer+Data.h
//  TeamTap
//
//  Created by Jason Cox on 28/04/2014.
//  Copyright (c) 2014 Audio and Pixels Pty. Limited. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface AFJSONResponseSerializer_Data : AFJSONResponseSerializer

@end
