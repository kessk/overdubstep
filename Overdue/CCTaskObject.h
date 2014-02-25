//
//  CCTaskObject.h
//  Overdue
//
//  Created by Kessler Koh on 2/14/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTaskObject : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL completion;

-(id)initWithData:(NSDictionary *)data;
@end
