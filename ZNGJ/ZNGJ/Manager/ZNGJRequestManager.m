//
//  ZNGJRequestManager.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJRequestManager.h"
#import "ZNGJRegisterRequest.h"
#import "ZNGJLoginRequest.h"
#import "ZNGJLogoutRequest.h"
#import "ZNGJAuthenticationCodeRequest.h"
#import "ZNGJPushDeviceTokenRequest.h"
#import "ZNGJAcceptOrderRequest.h"
#import "ZNGJAuthSubmitRequest.h"
#import "ZNGJImageUploadTokenRequest.h"

static ZNGJRequestManager* mSharedManager = nil;

NSString* const hostAuthURL = @"http://118.178.180.143:7600/auth/%@";	// 云服务器
//NSString* const hostAuthURL = @"http://localhost:7600/auth/%@";
//NSString* const hostAuthURL = @"http://10.197.113.226:7600/auth/%@";   // 公司无线IP

@interface ZNGJRequestManager()

@end

@implementation ZNGJRequestManager

+(ZNGJRequestManager*) sharedManager
{
	if (!mSharedManager) {
		mSharedManager = [[ZNGJRequestManager alloc] init];
	}
	
	return mSharedManager;
}

-(ZNGJRequest*) createRequest:(EnumRequestType)requestType
{
	ZNGJRequest* request = nil;
	switch (requestType) {
		case ENUM_REQUEST_REGISTER:
			request = [[ZNGJRegisterRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"register"];
			break;
		case ENUM_REQUEST_LOGIN:
			request = [[ZNGJLoginRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"login"];
			break;
		case ENUM_REQUEST_LOGOUT:
			request = [[ZNGJLogoutRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"logout"];
			break;
		case ENUM_REQUEST_AUTHENTICATION_CODE:
			request = [[ZNGJAuthenticationCodeRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"message_auth"];
			break;
		case ENUM_REQUEST_REGISTER_DEVICE_TOKEN:
			request = [[ZNGJPushDeviceTokenRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"push_device_token"];
			break;
		case ENUM_REQUEST_ACCEPT_ORDER:
			request = [[ZNGJAcceptOrderRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"accept_order"];
			break;
		case ENUM_REQUEST_AUTH_SUBMIT:
			request = [[ZNGJAuthSubmitRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"auth_submit"];
			break;
		case ENUM_REQUEST_IMAGE_UPLOAD_TOKEN:
			request = [[ZNGJImageUploadTokenRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"image_upload_token"];
			break;
		default:
			break;
	}
	
	return request;
}

@end
