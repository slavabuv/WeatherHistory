//
//  WHDataModel.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHDataModel.h"

@implementation WHDataModel

+ (NSDateFormatter *)dateFormatter
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[ dateFormatter setDateStyle:NSDateFormatterLongStyle];
	
	return [dateFormatter autorelease];
}

+ (NSTimeInterval)timeIntervalOneDay:(NSTimeInterval)timeInterval
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSString *str = [dateFormatter stringFromDate:[NSDate date]];
	
	return [[dateFormatter dateFromString:str] timeIntervalSince1970];
}

+ (NSString *)dateAsString:(NSTimeInterval)timeInterval
{
	return [[self dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

+ (UIColor *)colorOfTemp:(float)temp
{
	if (temp > 10)
	{
		return [UIColor colorWithHue:2 saturation:100 brightness:100-temp alpha:0.70f];
		//return [UIColor colorWithRed:((temp-10)*255.0f/50.0f)/255.0f green:0.0f blue:0.0f alpha:((temp-10)*255.0f/50.0f)/255.0f];
	}
	else
	{
		return [UIColor colorWithRed:1.f green:1.f blue:(temp*255.0f/50.0f)/255.0f  alpha:1.0f];
	}
}

@end

@implementation WHBaseDataObject

- (id)initWithDictionary:(NSDictionary *)dic
{
	if (self = [super init])
	{
		_dictionary = [dic retain];
	}
	
	return self;
}

- (NSDictionary *)dictionary
{
	return _dictionary;
}

- (void)dealloc
{
	[_dictionary release];
	[super dealloc];
}

@end

@implementation WHForecastTemp

- (NSString *)time
{
	return [NSString stringWithFormat:@"%@ %@", [self hour], [self min]];
}

- (NSString *)min
{
	return [NSString stringWithFormat:@"%@ min", [[_dictionary objectForKey:@"date"] objectForKey:@"min"]];
}

- (NSString *)hour
{
	return [NSString stringWithFormat:@"%@ hour", [[_dictionary objectForKey:@"date"] objectForKey:@"hour"]];
}

- (NSString *)temp
{
	return [NSString stringWithFormat:@"%@ °С", [_dictionary objectForKey:@"tempm"]];
}

@end

@implementation WHForecastDataObject

- (NSTimeInterval)date
{
	NSDictionary *dicHistory = [_dictionary objectForKey:@"history"];
	NSDictionary *dicDate = [dicHistory objectForKey:@"date"];
	NSString *strPretty = [dicDate objectForKey:@"pretty"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[ dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSDate *date = [dateFormatter dateFromString:strPretty];
	
	NSLog(@"%f", [date timeIntervalSince1970]);
	return [date timeIntervalSince1970];
}

- (NSString *)dateAsSring
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSTimeInterval timeInterval = [self date];
	NSString *strResult = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];

	return strResult;
}

- (NSArray *)observations
{
	if (_observations == nil)
	{
		_observations = [NSMutableArray new];
		NSDictionary *dicHistory = [_dictionary objectForKey:@"history"];
		NSArray *array = [dicHistory objectForKey:@"observations"];
		for (NSDictionary *dicInfo in array)
		{
			WHForecastTemp *forecastTemp = [[WHForecastTemp alloc] initWithDictionary:dicInfo];
			[_observations addObject:forecastTemp];
			[forecastTemp release];
		}
	}
	
	return _observations;
}

- (NSString *)icon
{
	return [_dictionary objectForKey:@"icon"];
}

- (NSDictionary *)dailysummary
{
	NSDictionary *dicHistory = [_dictionary objectForKey:@"history"];
	return [dicHistory objectForKey:@"dailysummary"];
}

@end

@implementation WHProverbsDataObject

- (NSString *)name
{
	return [_dictionary objectForKey:@"name"];
}

- (NSString *)description
{
	return [_dictionary objectForKey:@"description"];
}

- (NSDictionary *)rulers
{
	return nil;
}

@end