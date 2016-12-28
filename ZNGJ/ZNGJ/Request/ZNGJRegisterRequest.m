//
//  ZNGJRegisterRequest.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJRegisterRequest.h"

@implementation ZNGJRegisterRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_POST;
		self.params = @{@"username" : @"13616549781", @"passward" : @"123456"};
	}
	return self;
}

@end
