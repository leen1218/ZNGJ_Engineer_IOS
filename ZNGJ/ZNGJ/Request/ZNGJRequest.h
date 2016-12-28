//
//  ZNGJRequest.h
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef enum {
	ENUM_REQUEST_GET = 0,
	ENUM_REQUEST_POST,
	ENUM_REQUEST_DEFAULT = ENUM_REQUEST_GET
} EnumRequestActionType;

@protocol RequestHandler <NSObject>

-(void)onSuccess: (id)response;
-(void)onFailure: (NSError*)error;

@end


//Base Request
@interface ZNGJRequest : NSObject

@property(nonatomic, weak) id<RequestHandler> handler;
@property(nonatomic, strong) NSString* method;
@property(nonatomic, strong) NSDictionary* params;
@property(nonatomic) EnumRequestActionType requestType;

-(void) start;

@end
