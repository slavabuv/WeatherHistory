//
//  WHBaseStorageModelController.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHBaseStorageModelController.h"

@implementation WHBaseStorageModelController

- (id)init
{
    if (self = [super init])
    {
        _dataSource = [NSMutableArray new];
    }
    
    return self;
}

@end
