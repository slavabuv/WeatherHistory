//
//  WHDataModel.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHConstants.h"

@interface WHDataModel : NSObject

+ (NSTimeInterval)timeIntervalOneDay:(NSTimeInterval)timeInterval;
+ (NSString *)dateAsString:(NSTimeInterval)timeInterval;
+ (UIColor *)colorOfTemp:(float)temp;

@end

@interface WHBaseDataObject : NSObject
{
	NSDictionary *_dictionary;
}

- (id)initWithDictionary:(NSDictionary *)dic;
- (NSDictionary *)dictionary;

@end

@interface WHForecastTemp : WHBaseDataObject

- (NSString *)icon;
- (NSString *)time;
- (NSString *)min;
- (NSString *)hour;
- (NSString *)temp;

@end

@interface WHForecastDataObject : WHBaseDataObject
{
	NSMutableArray *_observations;
}

- (NSTimeInterval)date;
- (NSString *)dateAsSring;
- (NSDictionary *)dailysummary;
- (NSArray *)observations;
- (NSString *)icon;

@end

@interface WHProverbsDataObject : WHBaseDataObject
{
	
}

- (NSString *)name;
- (NSString *)description;
- (NSDictionary *)rulers;

@end