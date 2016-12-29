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
	ENUM_REQUEST_AUTHENTICATION_CODE
} EnumRequestType;

@interface ZNGJRequestManager : NSObject

// singleton
+(ZNGJRequestManager*) sharedManager;

// request factory
-(ZNGJRequest*) createRequest:(EnumRequestType) requestType;

@end
