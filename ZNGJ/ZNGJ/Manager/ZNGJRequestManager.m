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
#import "ZNGJAuthenticationCodeRequest.h"

static ZNGJRequestManager* mSharedManager = nil;

//NSString* const hostAuthURL = @"https://www.yixiuhz.online/auth/%@";
//NSString* const hostAuthURL = @"http://118.178.180.143:7600/auth/%@";
NSString* const hostAuthURL = @"http://localhost:7600/auth/%@";

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
		case ENUM_REQUEST_AUTHENTICATION_CODE:
			request = [[ZNGJAuthenticationCodeRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthURL, @"message_auth"];
			break;
		default:
			break;
	}
	
	return request;
}

@end
