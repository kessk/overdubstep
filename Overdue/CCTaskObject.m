//
//  CCTaskObject.m
//  Overdue
//
//  Created by Kessler Koh on 2/14/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import "CCTaskObject.h"

@implementation CCTaskObject

-(id)init
{
    NSDictionary *tempDictionary = [[NSDictionary alloc]init];
    self = [self initWithData:tempDictionary];
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self.title = data[TASK_TITLE];
    self.description = data[TASK_DESCRIPTION];
    self.date = data[TASK_DATE];
    if ([data[TASK_COMPLETION]  isEqual: @NO]) {
        self.completion = NO;
    } else {
        self.completion = YES;
    }
    return self;
}
@end
