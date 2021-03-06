//
//  ZNGJRequestManager.h
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNGJRequest.h"

typedef enum {
	ENUM_REQUEST_REGISTER = 0,
	ENUM_REQUEST_LOGIN,
	ENUM_REQUEST_LOGOUT,
	ENUM_REQUEST_AUTHENTICATION_CODE,
	ENUM_REQUEST_REGISTER_DEVICE_TOKEN,
	ENUM_REQUEST_ACCEPT_ORDER,
	ENUM_REQUEST_AUTH_SUBMIT,
	ENUM_REQUEST_IMAGE_UPLOAD_TOKEN
} EnumRequestType;

@interface ZNGJRequestManager : NSObject

// singleton
+(ZNGJRequestManager*) sharedManager;

// request factory
-(ZNGJRequest*) createRequest:(EnumRequestType) requestType;

@end
