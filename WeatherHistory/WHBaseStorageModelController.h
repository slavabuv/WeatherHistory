//
//  WHBaseStorageModelController.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHStorage.h"
#import "WHDataModel.h"
#import "WHConstants.h"

@interface WHBaseStorageModelController : NSObject
{
    NSMutableArray  *_dataSource;
}

@end
