//
//  WHProverbsModelController.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHBaseStorageModelController.h"

@interface WHProverbsModelController : WHBaseStorageModelController

+ (void)proverbsForDate:(NSTimeInterval)timeInterval
			  localData:(void(^)(NSArray *array))localData
			remouteData:(void(^)(NSArray *array))remoteData;
@end