//
//  WHForecastModelController.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHBaseStorageModelController.h"

@interface WHForecastModelController : WHBaseStorageModelController

+ (void)forecastForDate:(NSTimeInterval)timeInterval
			  localData:(void(^)(WHForecastDataObject *forecast))localData
			remouteData:(void(^)(WHForecastDataObject *forecast))remoteData;

@end