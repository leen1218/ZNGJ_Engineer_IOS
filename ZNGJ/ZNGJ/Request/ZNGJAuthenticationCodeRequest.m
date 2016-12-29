//
//  ZNGJRegisterRequest.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJAuthenticationCodeRequest.h"

@implementation ZNGJAuthenticationCodeRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_GET;
		self.params = @{@"cellphone" : @"13616549781"};
	}
	return self;
}

@end
