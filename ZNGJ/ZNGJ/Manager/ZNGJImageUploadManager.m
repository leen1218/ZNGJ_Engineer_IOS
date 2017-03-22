//
//  ZNGJImageUploadManager.m
//  ZNGJ
//
//  Created by en li on 17/3/20.
//  Copyright © 2017年 en li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImageView+AFNetworking.h>
#import "ZNGJImageUploadManager.h"
#import <QiniuSDK.h>

static ZNGJImageUploadManager* mSharedManager = nil;

@implementation ZNGJImageUploadManager

+(ZNGJImageUploadManager*) sharedManager
{
	if (!mSharedManager) {
		mSharedManager = [[ZNGJImageUploadManager alloc] init];
	}
	
	return mSharedManager;
}

-(BOOL) uploadImage:(UIImage *)image withToken:(NSString *)token savedAs:(NSString*) name
{
	QNUploadManager *upManager = [[QNUploadManager alloc] init];
	NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
	if (!image) {
		return false;
	}
	[upManager putData:imageData key:name token:token
			  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
				  NSLog(@"%@", info);
				  NSLog(@"%@", resp);
			  } option:nil];
	
	return true;
}

-(void) downloadImage:(UIImageView*)imageview fromURL:(NSString*) urlString {
	NSURL *lSourceURL = [NSURL URLWithString:urlString];
	[imageview setImageWithURL:lSourceURL];
}

@end
