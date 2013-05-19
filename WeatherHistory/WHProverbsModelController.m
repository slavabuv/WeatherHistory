//
//  WHProverbsModelController.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHProverbsModelController.h"

@implementation WHProverbsModelController

+ (void)proverbsForDate:(NSTimeInterval)timeInterval
			  localData:(void(^)(NSArray *array))localData
			remouteData:(void(^)(NSArray *array))remoteData
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		NSString *str = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
		
		__block NSTimeInterval timeIntervalForDay = [[dateFormatter dateFromString:str] timeIntervalSince1970];
		NSLog(@"%f", timeIntervalForDay);
		NSArray *result = [WHStorage proverbsForDate:timeIntervalForDay];
		if (result == nil || [result  count] == 0)
		{
			//load from internet
		}
		else
		{
			localData(result);
		}
	});
}

@end
