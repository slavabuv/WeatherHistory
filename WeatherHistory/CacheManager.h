//
//  CacheManager.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 19.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5.h"

@interface CacheManager : NSObject

+ (NSData *)dataWithContentsOfURL:(NSURL *)aURL
						  success:(void(^)(NSData *data))success
						  failure:(void(^)(NSError *error))failure;

+ (UIImage *)image:(NSString *)imageName success:(void(^)(UIImage *img))success failure:(void(^)(NSError *error))failure;

@end
