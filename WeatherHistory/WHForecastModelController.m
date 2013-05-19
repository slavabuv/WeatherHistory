//
//  WHForecastModelController.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHForecastModelController.h"

@implementation WHForecastModelController

+ (void)forecastForDate:(NSTimeInterval)timeInterval
			  localData:(void(^)(WHForecastDataObject *forecast))localData
			remouteData:(void(^)(WHForecastDataObject *forecast))remoteData
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		NSString *str = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
		
		__block NSTimeInterval timeIntervalForDay = [[dateFormatter dateFromString:str] timeIntervalSince1970];
		NSLog(@"%f", timeIntervalForDay);
		WHForecastDataObject *forecastObject = [WHStorage forecastForDate:timeIntervalForDay];
		if (forecastObject == nil)
		{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:kAPI_DateForman];
				NSString *strUrl = [NSString stringWithFormat:kAPI_Moscow, [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]]];
				[dateFormatter release];
				NSLog(@"%@", strUrl);
				NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
				NSError *error = nil;
				id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
				if (error == nil) 
				{
					WHForecastDataObject *forecast = [[WHForecastDataObject alloc] initWithDictionary:dic];
					
					[WHStorage forecastAdd:[NSArray arrayWithObject:forecast]];
					[forecast release];
					remoteData(forecast);
				}
				else
				{
					NSLog(@"%@", [error description]);
				}
			});
		}
		else
		{
			localData(forecastObject);
		}
	});
}

@end