//
//  WHStorage.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHConstants.h"
#import "WHDataModel.h"

#pragma mark WHStorageBaseObject

@interface WHStorageBaseObject : NSManagedObject

@property (nonatomic, retain) NSData *data;
@property (nonatomic, assign) double date;

@end

#pragma mark WHStorage

@interface WHStorage : NSObject

+ (void)forecastAdd:(NSArray *)array;
+ (WHForecastDataObject *)forecastForDate:(NSTimeInterval)time;

+ (NSArray *)proverbsForDate:(NSTimeInterval)time;

@end
