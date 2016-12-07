//
//  UserModel.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-16.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "UserModel.h"

#define MAX_DATA_ITEM   100


@interface UserModel ()
{
    NSMutableArray* _allData;
    NSString* _fileName;
    
    NSDictionary* _currentUser;
    NSString* _currentFileName;
    NSMutableArray* _currentHistoryArray;

    NSString* _currentWeekFileName;
    NSMutableArray* _currentWeekArray;
}

@property (nonatomic, strong) NSString *currentWrongFileName;
@property (nonatomic, strong) NSMutableArray *currentWrongArray;

@end



@implementation UserModel

static UserModel *sharedSingleton_ = nil;

+ (UserModel *) sharedInstance
{
	if (sharedSingleton_ == nil)
	{
		sharedSingleton_ = [[UserModel alloc]init];
        
	}
	return sharedSingleton_;
}

- (id)init
{
    self = [super init];
    
    [self reset];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reset) name:NOTIFY_NAME_login object:nil];
    
    return self;
}

//user
-(void)addUser:(NSString*)name age:(NSString*)age
{
    NSMutableArray* a2 = [NSMutableArray array];
    
    NSArray* a1 = [self allUser];
    if (a1) {
        [a2 addObjectsFromArray:a1];

        for (NSDictionary* dic1 in a2) {
            NSString* n1 = [dic1 objectForKey:KEY_USER_name];
            if (NSOrderedSame == [n1 caseInsensitiveCompare:name]) {
                [a2 removeObject:dic1];
                break;
            }
        }

    }

    [a2 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                       name, KEY_USER_name,
                       age, KEY_USER_age,
                       nil]];

    NSUserDefaults* d1 = [NSUserDefaults standardUserDefaults];
    [d1 setObject:a2 forKey:KEY_All_USER];
    [d1 synchronize];

}

-(NSArray*)allUser
{
    NSUserDefaults* d1 = [NSUserDefaults standardUserDefaults];
    return [d1 arrayForKey:KEY_All_USER];
}

-(NSDictionary*)currentUser
{
    if (_currentUser == nil) {
        NSUserDefaults* d1 = [NSUserDefaults standardUserDefaults];
        _currentUser = [d1 dictionaryForKey:KEY_Current_USER];
    }

    return [_currentUser copy];
}

-(void)setCurrentUser:(NSDictionary*)user
{
    NSUserDefaults* d1 = [NSUserDefaults standardUserDefaults];
    [d1 setObject:user forKey:KEY_Current_USER];
    [d1 synchronize];
    
    _currentUser = [user copy];
    _currentFileName = nil;
    _currentHistoryArray = nil;
}

-(NSArray*)zuheForCurrentUser
{
    NSDictionary* user = [self currentUser];

    NSUserDefaults* d1 = [NSUserDefaults standardUserDefaults];
    NSArray* a1 = [d1 arrayForKey:[NSString stringWithFormat:@"%@%@",[user objectForKey:KEY_USER_name], KEY_Current_USER_zuhe]];
    if (nil == a1) {
        NSMutableArray* tmp1 = [NSMutableArray array];
        for (int i=0; i<12; i++) {
            NSDictionary* dic1 = [NSDictionary dictionary];
            [tmp1 addObject:dic1];
        }
        
        [self setZuheForCurrentUser:tmp1];
        a1 = tmp1;
    }
    return [a1 copy];
}

-(void)setZuheForCurrentUser:(NSArray*)zuhe
{
    NSDictionary* user = [self currentUser];
    NSUserDefaults* d1 = [NSUserDefaults standardUserDefaults];
    [d1 setObject:zuhe forKey:[NSString stringWithFormat:@"%@%@",[user objectForKey:KEY_USER_name], KEY_Current_USER_zuhe]];
    [d1 synchronize];
    
}

//wrong
- (void)addWrongForCurrentUser:(NSDictionary *)result {
    if (result == nil) {
        return;
    }
    
    [self readDataIfNeed];
    
    BOOL needAdd = YES;
    for (NSInteger i = 0; i < [_currentWrongArray count]; i++) {
        NSDictionary *wrong = [_currentWrongArray objectAtIndex:i];
        if ([[result objectForKey:KEY_wrong_date] isEqualToString:[wrong objectForKey:KEY_wrong_date]]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[wrong objectForKey:KEY_wrong_date] forKey:KEY_wrong_date];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[wrong objectForKey:KEY_wrong_data]];
            [array addObjectsFromArray:[result objectForKey:KEY_wrong_data]];
            [dic setObject:array forKey:KEY_wrong_data];
            
            [_currentWrongArray replaceObjectAtIndex:i withObject:dic];
            
            needAdd = NO;
            break;
        }
    }
    
    if (needAdd) {
        [_currentWrongArray addObject:result];
    }
    
    BOOL ret = [_currentWrongArray writeToFile:_currentWrongFileName atomically:YES ];
    if (!ret) {
        NSLog(@"save wrong plist failed");
    }
}


//history
-(NSArray*)historyResultForCurrentUser
{
    [self readDataIfNeed];
    
    return _currentHistoryArray;
}

-(NSArray*)weekResultForCurrentUser
{
    [self readDataIfNeed];
    
    //如果当前周与上次记录不是同一周，并且上周没有计算过，计算周成绩
    [self caculateWeekValue];

    return _currentWeekArray;
}

- (NSArray *)wrongResultForCurrentUser {
    [self readDataIfNeed];
    
    return _currentWrongArray;
}

//这里后面要加止时间段，当前就先做全部
- (NSArray *)getTongJiData:(NSInteger)days from:(NSString *)from to:(NSString *)to {
    [self readDataIfNeed];
    
    if ([KenUtils isEmpty:from] || [KenUtils isEmpty:to]) {
        days = days == 0 ? 7 : days;
        to = [KenUtils getStringFromDate:[NSDate date] format:kDateFormat];

        NSDate *fromDate = [KenUtils getDateFromDate:[NSDate date] day:-days];//前一天
        from = [KenUtils getStringFromDate:fromDate format:kDateFormat];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    for (NSInteger i = 0; i < [_currentWrongArray count]; i++) {
        if ([KenUtils date:[KenUtils getDateFromString:[[_currentWrongArray objectAtIndex:i] objectForKey:KEY_wrong_date] format:kDateFormat]
             isBetweenDate:[KenUtils getDateFromString:from format:kDateFormat]
                   andDate:[KenUtils getDateFromString:to format:kDateFormat]]) {
            [data addObject:[_currentWrongArray objectAtIndex:i]];
        }
    }
    
    return [self getTongJiDataDuringData:data];
}

- (NSArray *)getTongJiDataDuringData:(NSArray *)data {
    int fuhao1 = 0;
    int fuhao2 = 0;
    int fuhao4 = 0;
    int fuhao8 = 0;
    
    NSMutableArray *temp = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, nil];
    
    for (NSInteger i = 0; i < [data count]; i++) {
        NSArray *oneDayData = [[data objectAtIndex:i] objectForKey:KEY_wrong_data];
        for (NSInteger m = 0; m < [oneDayData count]; m++) {
            NSArray *data = [[oneDayData objectAtIndex:m] objectAtIndex:1];
            BOOL isNumber = YES;
            for (NSInteger j = 2; j < [data count]; j++) {
                int value = [[data objectAtIndex:j] intValue];
                if (isNumber) {
                    while (value >= 0) {
                        if (value > 10) {
                            [self addAtIndex:temp value:value % 10];
                            value /= 10;
                        } else {
                            [self addAtIndex:temp value:value];
                            break;
                        }
                    }
                } else {
                    if (value == 1) {
                        fuhao1++;
                    } else if (value == 2) {
                        fuhao2++;
                    } else if (value == 4) {
                        fuhao4++;
                    } else if (value == 8) {
                        fuhao8++;
                    }
                }
                isNumber = !isNumber;
            }
        }
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:fuhao1], [NSNumber numberWithInt:fuhao2],
                              [NSNumber numberWithInt:fuhao4], [NSNumber numberWithInt:fuhao8], nil];
    [result addObjectsFromArray:temp];
    return result;
}

- (void)addAtIndex:(NSMutableArray *)array value:(int)value {
    int index = 0;
    if (value == 0) {
        index = 9;
    } else {
        index = --value;
    }
    
    [array replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:[[array objectAtIndex:index] intValue] + 1]];
}

-(void)addHistoryItemForCurrentUser:(NSDictionary*)result
{
    [self readDataIfNeed];
    
    if ([_currentHistoryArray count] == (MAX_DATA_ITEM-1)) {
        [_currentHistoryArray removeObjectAtIndex:0];
    }
    if ([_currentWeekArray count] == (MAX_DATA_ITEM-1)) {
        [_currentWeekArray removeObjectAtIndex:0];
    }

    //计算上周成绩，如果当前时间跟上次记录不是同一周
    [self caculateWeekValue];

    
    [_currentHistoryArray addObject:result];
    
    [self writeData];
    
}

-(NSArray*)historyResultForUser:(NSString*)name
{
    return nil;
}

-(void)addHistoryItem:(NSDictionary*)result forUser:(NSString*)name
{
    

}

#pragma mark private
-(void)reset
{
    if (nil == _currentUser) {
        [self currentUser];
    }
//    if (_allData) {
//        [self writeData];
//    }
//    
//    
//    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
//    _fileName = [[doucumentsDirectiory stringByAppendingPathComponent:
//                  [NSString stringWithFormat:@"%@.plist", ((AppDelegate*)[[UIApplication sharedApplication] delegate]).user]]retain];
    
}

-(void)resetFilenameIfNeed
{
    if (nil == _currentFileName) {
        NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
        _currentFileName = [doucumentsDirectiory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@.plist", [_currentUser objectForKey:KEY_USER_name]]];
        _currentWeekFileName = [doucumentsDirectiory stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@.week.plist", [_currentUser objectForKey:KEY_USER_name]]];
        _currentWrongFileName = [doucumentsDirectiory stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"%@.wrong.plist", [_currentUser objectForKey:KEY_USER_name]]];
    }

}

-(void)readDataIfNeed
{
    [self resetFilenameIfNeed];

    if (nil == _currentHistoryArray) {
        _currentHistoryArray = [[NSMutableArray alloc] initWithContentsOfFile:_currentFileName];
        if (nil == _currentHistoryArray) {
            _currentHistoryArray = [[NSMutableArray alloc]init];
        }

        _currentWeekArray = [[NSMutableArray alloc] initWithContentsOfFile:_currentWeekFileName];
        if (nil == _currentWeekArray) {
            _currentWeekArray = [[NSMutableArray alloc]init];
        }
        
        _currentWrongArray = [[NSMutableArray alloc] initWithContentsOfFile:_currentWrongFileName];
        if (nil == _currentWrongArray) {
            _currentWrongArray = [[NSMutableArray alloc]init];
        }
    }
}

-(void)writeData
{
    
	BOOL ret = [_currentHistoryArray writeToFile:_currentFileName atomically:YES ];
	if (!ret) {
		NSLog(@"save plist failed");
	}
}

-(void)writeWeekData
{
	BOOL ret = [_currentWeekArray writeToFile:_currentWeekFileName atomically:YES ];
	if (!ret) {
		NSLog(@"save plist failed");
	}
}


-(void)caculateWeekValue {
    
    //计算综合成绩，按周计算
    //这次成绩和上次不是一个周的，计算上个周的成绩
    NSUInteger lastWeek = 0;
    NSUInteger currentWeek = 0;
    BOOL bChanged = NO;
    
    NSUInteger total = [_currentHistoryArray count];
    if (total < 5) {
        return;
    }
//    NSMutableDictionary* lastItem = [_currentHistoryArray objectAtIndex:(total-2)];
//    NSMutableDictionary* currentItem = [_currentHistoryArray objectAtIndex:(total-1)];
    NSMutableDictionary* lastItem = [_currentHistoryArray objectAtIndex:(total-1)];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //and set firstWeekday to 2. (1 == Sunday and 7 == Saturday)
    [currentCalendar setFirstWeekday:2];
    [currentCalendar setLocale:[NSLocale autoupdatingCurrentLocale]];
//    NSLocale* local1 = [currentCalendar locale];
//    NSString* s1 = [local1 localeIdentifier];
//    NSTimeZone* z1 = [currentCalendar timeZone];
//    NSString* s2 = [z1 name];
//    z1 = [NSTimeZone localTimeZone];
//    s2 = [z1 name];

    lastWeek = [currentCalendar  ordinalityOfUnit:NSWeekCalendarUnit
                                           inUnit:NSEraCalendarUnit
                                          forDate:[lastItem objectForKey:KEY_History_date]];
    NSDate* now = [NSDate date];
    currentWeek = [currentCalendar  ordinalityOfUnit:NSWeekCalendarUnit
                                              inUnit:NSEraCalendarUnit
                                             forDate:now];
//    currentWeek-=1;   //test last week
    if (lastWeek != currentWeek) {
        
        //如果已经计算过
        NSDictionary* dicWeek1 = [_currentWeekArray lastObject];
        if (dicWeek1) {
            NSUInteger lastResultWeek = [currentCalendar  ordinalityOfUnit:NSWeekCalendarUnit
                                                                    inUnit:NSEraCalendarUnit
                                                                   forDate:[dicWeek1 objectForKey:KEY_week_number]];

            if (lastWeek == lastResultWeek) {
                return;
            }
        }
        
        
        //获取上周所有记录
        NSMutableArray* arrayLastWeek = [NSMutableArray array];
        NSInteger tmpIndex = [_currentHistoryArray indexOfObject:lastItem];
//        tmpIndex--;
        while (tmpIndex >= 0) {
            NSMutableDictionary* tmpDic = [_currentHistoryArray objectAtIndex:tmpIndex];
            NSUInteger tmpWeek = [currentCalendar  ordinalityOfUnit:NSWeekCalendarUnit
                                                             inUnit:NSEraCalendarUnit
                                                            forDate:[tmpDic objectForKey:KEY_History_date]];
            if (tmpWeek != lastWeek) {
                break;
            }
            [arrayLastWeek addObject:tmpDic];
            
            tmpIndex--;
        }
        
        NSDate* date1 = [lastItem objectForKey:KEY_History_date];
        
        NSInteger tmpCnt = [arrayLastWeek count];
        //2）每周答题数低于5次的，为无效周，该周不取值。待下一次有效周产生时，线段连接最近两次有效周。
        if (tmpCnt < 5) {
            //invalid
//            NSMutableDictionary* weekItem = [NSMutableDictionary dictionary];
//            [weekItem setObject:date1 forKey:KEY_week_number];
//            [weekItem setObject:[NSNumber numberWithUnsignedInteger:0] forKey:KEY_week_zonghe];
//            [_currentWeekArray addObject:weekItem];
//            bChanged = YES;
        }
        else {
            /*
             （1）记录每周成绩，去掉最高的10%和最低的10%（四舍五入），剩下的80%取算术平均值，为本周图标上所对应的数值。
             */
            NSArray* arrayLastWeekSorted =
            
            [arrayLastWeek sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary* obj1, NSMutableDictionary* obj2) {
                int i1 = [[obj1 objectForKey:KEY_History_zonghe]intValue];
                int i2 = [[obj2 objectForKey:KEY_History_zonghe]intValue];
                if (i1 == i2) {
                    return NSOrderedSame;
                }
                else if (i1 > i2) {
                    return NSOrderedAscending;
                }
                else {
                    return NSOrderedDescending;
                }
            }];
            
            arrayLastWeek = [NSMutableArray arrayWithArray:arrayLastWeekSorted];
            
//            int delCnt = tmpCnt * 10 /100;
            NSInteger delCnt = tmpCnt * 13 /100;  //13%
            for (int iDel=0; iDel < delCnt; iDel++) {
                [arrayLastWeek removeObjectAtIndex:0];
                [arrayLastWeek removeLastObject];
            }
            
            tmpCnt = [arrayLastWeek count];
            int iWeekValue = 0;
            for (NSDictionary* d1 in arrayLastWeek) {
                iWeekValue += [[d1 objectForKey:KEY_History_zonghe]intValue];
            }
            iWeekValue /= tmpCnt;

            NSMutableDictionary* weekItem = [NSMutableDictionary dictionary];
            [weekItem setObject:date1 forKey:KEY_week_number];
            [weekItem setObject:[NSNumber numberWithInt:iWeekValue] forKey:KEY_week_zonghe];
            [_currentWeekArray addObject:weekItem];
            bChanged = YES;
        }
        
//        //上次成绩的周和本周周数有空周，补零
//        for (NSUInteger w = lastWeek+1; w<currentWeek; w++) {
//            NSMutableDictionary* weekItem = [NSMutableDictionary dictionary];
//            date1 = [date1 dateByAddingTimeInterval:(7*24*60*60)];
//            [weekItem setObject:date1 forKey:KEY_week_number];
//            [weekItem setObject:[NSNumber numberWithUnsignedInteger:0] forKey:KEY_week_zonghe];
//            [_currentWeekArray addObject:weekItem];
//            bChanged = YES;
//        }
    }

    //    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    //    NSDate * dateA = [formatter dateFromString:@"2012-12-31 06:09:00 +1100"];
    

    if (bChanged) {
        [self writeWeekData];
    }
}

@end
