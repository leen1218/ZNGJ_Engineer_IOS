//
//  ZNGJImageUploadManager.h
//  ZNGJ
//
//  Created by en li on 17/3/20.
//  Copyright © 2017年 en li. All rights reserved.
//

#ifndef ZNGJImageUploadManager_h
#define ZNGJImageUploadManager_h

#import <UIKit/UIKit.h>

@interface ZNGJImageUploadManager : NSObject

// singleton
+(ZNGJImageUploadManager*) sharedManager;

// upload image
-(BOOL) uploadImage:(UIImage*) image withToken:(NSString*) token savedAs:(NSString*) name;

@end




#endif /* ZNGJImageUploadManager_h */
