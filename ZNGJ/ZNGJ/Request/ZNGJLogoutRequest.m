//
//  ZNGJLoginRequest.m
//  baoxincai
//
//  Created by en li on 16/5/12.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJLogoutRequest.h"

@implementation ZNGJLogoutRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_GET;
		self.params = @{@"username" : @"13616549781"};
	}
	return self;
}

@end
