//
//  ZNGJLoginRequest.m
//  baoxincai
//
//  Created by en li on 16/5/12.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJAcceptOrderRequest.h"

@implementation ZNGJAcceptOrderRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_POST;
		self.params = @{@"orderId" : @"0", @"engineerId":@"0"};
	}
	return self;
}

@end
