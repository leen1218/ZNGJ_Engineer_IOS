//
//  ZNGJRequest.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "ZNGJRequest.h"

@implementation ZNGJRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_DEFAULT;
		self.params = @{};
		self.handler = nil;
	}
	return self;
}

-(void) start
{
	AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
	//manager.requestSerializer = [AFJSONRequestSerializer serializer];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
	
	switch (self.requestType) {
		case ENUM_REQUEST_GET:
		{
			[manager GET:self.method
			   parameters:self.params
				 progress:nil
				  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
					  [self.handler onSuccess:responseObject];
				  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
					  [self.handler onFailure:error];
				  }];
			break;
		}
		case ENUM_REQUEST_POST:
		{
			[manager POST:self.method
			   parameters:self.params
				 progress:nil
				  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
					  [self.handler onSuccess:responseObject];
				  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
					  [self.handler onFailure:error];
				  }];
		}
		default:
			break;
	}
}

@end
