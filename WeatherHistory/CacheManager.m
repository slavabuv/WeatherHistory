//
//  CacheManager.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 19.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager(Hidden)

+ (NSString *)filePathInCache:(NSString *)aPath;
+ (NSData *)dataWithContentsOfFile:(NSString *)aName;
+ (void)saveData:(NSData *)aData withName:(NSString *)aName;
+ (NSString *)dpi;
@end;

@implementation CacheManager

#pragma mark Hidden declaration

#define kStringCachePath @"Library/Caches"
#define kStringServerImagePath @"v1.5/media"

+ (NSString *)filePathInCache:(NSString *)aPath
{
	NSString *strNameMD5 = [aPath md5];
	
	return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:kStringCachePath], strNameMD5];
}

+ (NSData *)dataWithContentsOfFile:(NSString *)aName
{
	NSString *fileNameInCache = [self filePathInCache:aName];
	if ([[NSFileManager defaultManager] fileExistsAtPath:fileNameInCache])
	{
		return [NSData dataWithContentsOfFile:fileNameInCache];
	}
	else
	{
		NSArray *fileNameArray = [aName componentsSeparatedByString:@"."];
		if ([fileNameArray count] == 2)
		{
			NSString *fileName = [fileNameArray objectAtIndex:0];
			NSRange range = [fileName rangeOfString:@"?" options:NSBackwardsSearch];
			if (range.length > 0)
				fileName = [fileName substringFromIndex:range.location + range.length];
			range = [fileName rangeOfString:@"/" options:NSBackwardsSearch];
			if (range.length > 0)
				fileName = [fileName substringFromIndex:range.location + range.length];
			
			NSString *fileNameInMainBundle = [[NSBundle mainBundle] pathForResource:fileName ofType:[fileNameArray objectAtIndex:1]];
			if ([[NSFileManager defaultManager] fileExistsAtPath:fileNameInMainBundle])
			{
				return [NSData dataWithContentsOfFile:fileNameInMainBundle];
			}
		}
	}
	
	return nil;
}

+ (NSDictionary *)attributesForFile:(NSString *)fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:fileName]) return nil;
	
	NSError *attributesRetrievalError = nil;
	NSDictionary *attributes = [fileManager attributesOfItemAtPath:fileName
															 error:&attributesRetrievalError];
	
	if (!attributes) {
		return nil;
	}
	
	NSMutableDictionary *returnedDictionary =
	[NSMutableDictionary dictionaryWithObjectsAndKeys:
	 [attributes fileType], @"fileType",
	 [attributes fileModificationDate], @"fileModificationDate",
	 [attributes fileCreationDate], @"fileCreationDate",
	 [NSNumber numberWithUnsignedLongLong:[attributes fileSize]], @"fileSize",
	 nil];
	
	return returnedDictionary;
}

+ (NSDate *)dateLastModificationFile:(NSString *)fileName
{
	NSDictionary *dic = [self attributesForFile:fileName];
	return [dic objectForKey:@"fileModificationDate"];
}

+ (void)saveData:(NSData *)aData withName:(NSString *)aName
{
	[aData writeToFile:[self filePathInCache:aName] atomically:YES];
}

#pragma mark Public declaration

+ (NSData *)dataWithContentsOfURL:(NSURL *)aURL
						  success:(void(^)(NSData *data))success
						  failure:(void(^)(NSError *error))failure
{
	NSData *data = [self dataWithContentsOfFile:[aURL absoluteString]];
	
    if (data==nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
            //load
            NSError *error = nil;
            NSURLResponse * response = nil;
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:aURL];
            
            NSString *fileNameInCache = [self filePathInCache:[aURL absoluteString]];
            NSDate *date = [self dateLastModificationFile:fileNameInCache];
            if (date)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                [formatter setLocale:usLocale];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName: @"GMT"]];
                [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
                NSString *dateString = [[formatter stringFromDate:date] stringByAppendingString:@" GMT"];
                [urlRequest addValue:dateString forHTTPHeaderField:@"If-Modified-Since"];
                [formatter release];
                [usLocale release];
            }
            
            NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            if ( error )
            {
                failure(error);
            }
            else if (data == nil)
            {
                failure([NSError errorWithDomain:[NSString stringWithFormat:@"CashManager unknown error to load data from url '%@'", [aURL absoluteString]] code:-1 userInfo:nil]);
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //save
                    [self saveData:data withName:[aURL absoluteString]];
                    success(data);
                });
            }
            
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //save
            success(data);
        });
    }
	
	return data;
}

+ (UIImage *)image:(NSString *)imageName success:(void(^)(UIImage *img))success failure:(void(^)(NSError *error))failure
{
	if (imageName && [imageName length] > 0)
	{
		NSURL *url = [NSURL URLWithString:imageName];
		
		return [UIImage imageWithData:[self dataWithContentsOfURL:url
														  success:^(NSData *data)
									   {
										   UIImage *img = [UIImage imageWithData:data];
										   if (img)
											   success(img);
										   else
											   failure(nil);
									   }
														  failure:^(NSError *error)
									   {
										   failure(error);
									   }
									   //dataWithContentsOfURL
									   ]];
	}
	
	return nil;
}

@end
