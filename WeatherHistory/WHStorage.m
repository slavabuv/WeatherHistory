//
//  WHStorage.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHStorage.h"
#import "WHAppDelegate.h"


#pragma mark Storage constants

#define DefaulManagedObjectContext ((WHAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext
#define DefaulPersistentStoreCoordinator ((WHAppDelegate *)[[UIApplication sharedApplication] delegate]).persistentStoreCoordinator

#define kEntityKeyDate @"date"
#define kEntityKeyIdentifier @"identifier"

#define kEntityNameForecastHistory	@"History"

@implementation WHStorageBaseObject

@dynamic data;
@dynamic date;

@end

@implementation WHStorage

#pragma mark base functionals

+ (NSData *)dataFromObject:(id)obj
{
	if (obj)
	{
		NSMutableData *data = [[NSMutableData alloc] init];
		NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
		[archiver encodeObject:obj forKey:kJSONResponseTopLevel];
		[archiver finishEncoding];
		[archiver release];
		
		return [data autorelease];
	}
	
	return nil;
}

+ (id)objectFromData:(NSData *)data
{
	id obj = nil;
	
	if (data)
	{
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		obj = [unarchiver decodeObjectForKey:kJSONResponseTopLevel];
		[unarchiver finishDecoding];
		[unarchiver release];
	}
	
	return obj;
}

#pragma mark 

+ (void)forecastAdd:(NSArray *)array
{
	NSManagedObjectContext *managedObjectContext = [[[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType] autorelease];
	[managedObjectContext setPersistentStoreCoordinator:DefaulPersistentStoreCoordinator];
    
	NSError* error = nil;
	WHStorageBaseObject *forecastObjInStorage = nil;
	for (WHForecastDataObject *forecastObj in array)
	{
		error = nil;
		forecastObjInStorage = nil;
		
		NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityNameForecastHistory];
		NSString *predicateString = [NSString stringWithFormat:@"%@ == %%i", @"date"];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString, (int)[forecastObj date]]];

		NSError *error = nil;
		NSArray *arrayRequest = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
		
		if (error)
		{
			NSLog(@"error %@", [error description]);
		}
		else
		{
			if ([arrayRequest count] == 0)
			{
				forecastObjInStorage = [NSEntityDescription insertNewObjectForEntityForName:kEntityNameForecastHistory inManagedObjectContext:managedObjectContext];
				forecastObjInStorage.date = [forecastObj date];
				NSData *data = [self dataFromObject:[forecastObj dictionary]];
				forecastObjInStorage.data = data;
			}
		}
	}
	
	[managedObjectContext save:&error];
	if (error)
	{
		NSLog(@"error %@", [error description]);
	}
    
	[DefaulManagedObjectContext performSelectorOnMainThread:@selector(save:) withObject:nil waitUntilDone:YES];
}

+ (WHForecastDataObject *)forecastForDate:(NSTimeInterval)time
{
	NSLog(@"%f", time);
	NSManagedObjectContext *managedObjectContext = [[[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType] autorelease];
	[managedObjectContext setPersistentStoreCoordinator:DefaulPersistentStoreCoordinator];
	
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntityNameForecastHistory];
	NSString *predicateString = [NSString stringWithFormat:@"%@ == %%i", @"date"];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString, (int)time]];
	NSError *error = nil;
	NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (error)
	{
		NSLog(@"error %@", [error description]);
	}
	else
	{
		if ([array count]>0)
		{
			WHForecastDataObject *forecast = [[WHForecastDataObject alloc]  initWithDictionary:[self objectFromData:[(WHStorageBaseObject *)[array objectAtIndex:0] data]]];
			return [forecast autorelease];
		}
	}
	
    return nil;
}

+ (NSArray *)proverbsForDate:(NSTimeInterval)time;
{
	WHProverbsDataObject *obj1 = [[WHProverbsDataObject alloc] initWithDictionary:@{@"name":@"", @"description":@"Жаворонки летят — к теплу, зяблик — к стуже."}]; 
	WHProverbsDataObject *obj2 = [[WHProverbsDataObject alloc] initWithDictionary:@{@"name":@"", @"description":@"Гуси высоко летят — много воды будет, низко летят — мало."}]; 
	WHProverbsDataObject *obj3 = [[WHProverbsDataObject alloc] initWithDictionary:@{@"name":@"", @"description":@"Облака плывут высоко — к хорошей погоде."}]; 
	WHProverbsDataObject *obj4 = [[WHProverbsDataObject alloc] initWithDictionary:@{@"name":@"", @"description":@"Воробьи купаются в песке — к дождю."}]; 

	
	return @[obj1, obj2, obj3, obj4];
}

@end
