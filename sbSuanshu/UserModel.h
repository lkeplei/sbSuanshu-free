//
//  UserModel.h
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-16.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_All_USER    @"all_user"
#define KEY_Current_USER    @"current_user"

#define KEY_Current_USER_zuhe    @"current_user_zuhe"

#define KEY_USER_name    @"name"
#define KEY_USER_age    @"age"

#define KEY_History_date    @"h_date"
#define KEY_History_fuhao    @"h_fuhao"
#define KEY_History_mode    @"h_mode"
#define KEY_History_cnt    @"h_cnt"
#define KEY_History_duration    @"h_duration"
#define KEY_History_defen    @"h_defen"
#define KEY_History_nandu    @"h_nandu"
#define KEY_History_zonghe    @"h_zonghe"

#define KEY_zuhe_name    @"z_name"
#define KEY_zuhe_cnt    @"z_cnt"
#define KEY_zuhe_ratio1    @"z_ratio1"
#define KEY_zuhe_ratio2    @"z_ratio2"
#define KEY_zuhe_ratio3    @"z_ratio3"
#define KEY_zuhe_ratio4    @"z_ratio4"
#define KEY_zuhe_fanwei1    @"z_fanwei1"
#define KEY_zuhe_fanwei2    @"z_fanwei2"
#define KEY_zuhe_fanwei3    @"z_fanwei3"
#define KEY_zuhe_fanwei4    @"z_fanwei4"
#define KEY_zuhe_mode    @"z_mode"

#define KEY_week_number    @"w_week"
#define KEY_week_zonghe    @"w_zonghe"

//wrong
#define KEY_wrong_date      @"wrong_date"
#define KEY_wrong_data      @"wrong_data"

@interface UserModel : NSObject

@property(nonatomic, copy) NSDictionary* currentUser;

@property(nonatomic, copy) NSArray* zuheForCurrentUser;

+ (UserModel *) sharedInstance;

//user
-(void)addUser:(NSString*)name age:(NSString*)age;
-(NSArray*)allUser;

//wrong
- (void)addWrongForCurrentUser:(NSDictionary *)result;

//history
-(NSArray*)historyResultForCurrentUser;
-(void)addHistoryItemForCurrentUser:(NSDictionary*)result;

-(NSArray*)weekResultForCurrentUser;

- (NSArray *)wrongResultForCurrentUser;

- (NSArray *)getTongJiData:(NSInteger)days from:(NSString *)from to:(NSString *)to;
@end
