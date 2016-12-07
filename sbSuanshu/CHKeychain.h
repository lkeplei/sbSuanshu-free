//
//  CHKeychain.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-6-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end
