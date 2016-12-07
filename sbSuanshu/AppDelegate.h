//
//  AppDelegate.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define sb_notify_purchase_ok   @"sb_notify_purchase_ok"

#define KEY_USER_purchased  @"sb_key_purchased"

//old @"928461d483264945a6a670c41ab8bafa"
#define adsmogo_id @"6c96c91fc4bb4600934b90e984b058da"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, atomic) NSArray *tiku;

@property (nonatomic) BOOL bFreeVersion;

@end

void TTAlertNoTitle(NSString* message, id delegate);
void ssAlertNoTitle(NSString* message, NSString* btnTitle, id delegate);
