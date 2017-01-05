//
//  ZNGJRegisterRequest.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJPushDeviceTokenRequest.h"

@implementation ZNGJPushDeviceTokenRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_POST;
		self.params = @{@"cellphone" : @"13616549781", @"devicetoken" : @"devicetoken"};
	}
	return self;
}

@end
