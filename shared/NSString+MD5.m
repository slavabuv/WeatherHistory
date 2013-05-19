//
//  NSString+MD5.m
//  iDaBank
//
//  Created by Nikolay july on 11.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString(MD5)

- (NSString *) md5
{
	const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}
/*
- (NSString *) md5WithBase64
{
	const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
	NSData * data = [NSData dataWithBytes:result length:16];
	NSString * res = [data base64Encoding];
	return res;
}
*/
@end