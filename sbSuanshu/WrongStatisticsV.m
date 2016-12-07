//
//  WrongStatisticsV.m
//  sbSuanshu
//
//  Created by 刘坤 on 15/11/27.
//  Copyright © 2015年 hou guanhua. All rights reserved.
//

#import "WrongStatisticsV.h"
#import "UserModel.h"

#import "NSDate+Helpers.h"

#import "VRGCalendarView.h"

#define kMaxNumbers         (4)

@interface WrongStatisticsV () <VRGCalendarViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *dateStart;
@property (nonatomic, strong) NSString *dateEnd;
@property (nonatomic, strong) UILabel *labelDate;
@property (nonatomic, strong) UILabel *labelFast;
@property (nonatomic, strong) UIView *backgroundV;
@property (nonatomic, strong) UIView *fastSelectV;
@property (nonatomic, strong) UIView *calendarV;

@end

@implementation WrongStatisticsV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _backgroundV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"result_wrong_bg"]];
    [_backgroundV setUserInteractionEnabled:YES];
    [self addSubview:_backgroundV];
    
    //日期选择部分
    UIButton *custom = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"statistics_time_bg"]
                                      imagesec:[UIImage imageNamed:@"statistics_time_bg"] target:self action:@selector(customBtnClicked:)];
    custom.origin = CGPointMake(56, 44);
    [_backgroundV addSubview:custom];
    
    _labelDate = [KenUtils labelWithTxt:NSLocalizedString(@"statisticsSelect", nil) frame:(CGRect){0, 0, custom.size}
                                   font:[UIFont boldSystemFontOfSize:20] color:[UIColor colorWithHexString:@"0x4D402D"]];
    [custom addSubview:_labelDate];
    
    UIButton *fast = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"statistics_fast_bg"]
                                      imagesec:[UIImage imageNamed:@"statistics_fast_bg"] target:self action:@selector(fastBtnClicked:)];
    fast.origin = CGPointMake(CGRectGetMaxX(custom.frame) + 24, custom.originY);
    [_backgroundV addSubview:fast];
    
    _labelFast = [KenUtils labelWithTxt:NSLocalizedString(@"statisticsFastSel", nil) frame:(CGRect){0, 0, fast.size}
                                   font:[UIFont boldSystemFontOfSize:20] color:[UIColor colorWithHexString:@"0x4D402D"]];
    [fast addSubview:_labelFast];

    //初始布局
    [self setStatisLabel:nil topArray:nil maxOperator:nil];
    
    //fast view
    [self initFastV:(CGRect){fast.originX, CGRectGetMaxY(fast.frame), fast.size}];
}

- (void)initFastV:(CGRect)frame {
    _fastSelectV = [[UIView alloc] initWithFrame:(CGRect){frame.origin.x, frame.origin.y + 1, frame.size.width, frame.size.height * 4}];
    [_fastSelectV setBackgroundColor:[UIColor colorWithHexString:@"0xFEF2E4"]];
    [_backgroundV addSubview:_fastSelectV];
    
    [_fastSelectV addSubview:[self getSelectBtn:7 frame:(CGRect){0, 0, frame.size}]];
    [_fastSelectV addSubview:[self getSelectBtn:15 frame:(CGRect){0, frame.size.height, frame.size}]];
    [_fastSelectV addSubview:[self getSelectBtn:30 frame:(CGRect){0, frame.size.height * 2, frame.size}]];
    [_fastSelectV addSubview:[self getSelectBtn:90 frame:(CGRect){0, frame.size.height * 3, frame.size}]];

    [_fastSelectV setHidden:YES];
    
    //tap gesture
    UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFastSelect:)];
    tapTouch.delegate = self;
    [_backgroundV addGestureRecognizer:tapTouch];
}

- (UIButton *)getSelectBtn:(NSInteger)days frame:(CGRect)frame {
    UIButton *button = [KenUtils buttonWithImg:[NSString stringWithFormat:NSLocalizedString(@"statisticsFastDay", nil), days]
                                           off:0 zoomIn:NO image:nil
                                        imagesec:nil target:self action:@selector(selectBtnClicked:)];
    button.tag = days;
    button.frame = frame;
    [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor colorWithHexString:@"0xD3C8B5"].CGColor;
    
    return button;
}

- (void)setDataUI:(NSArray *)statistics {
    if ([statistics count] <= 0) {
        return;
    }
    
    //运算符中最大的一个
    NSArray *operatorArray = [statistics subarrayWithRange:NSMakeRange(0, 4)];
    NSInteger maxOperator = [[operatorArray firstObject] integerValue];
    for (NSInteger i = 1; i < [operatorArray count]; i++) {
        maxOperator = MAX(maxOperator, [[operatorArray objectAtIndex:i] integerValue]);
    }
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *numberArray = [statistics subarrayWithRange:NSMakeRange(4, [statistics count] - 4)];
    //数字中最大的三个
    for (NSInteger i = 0; i < [numberArray count]; i++) {
        NSNumber *value = [numberArray objectAtIndex:i];
        if ([array count] < kMaxNumbers - 1) {
            BOOL add = YES;
            for (NSInteger i = 0; i < [array count]; i++) {
                if ([value intValue] == [[array objectAtIndex:i] intValue]) {
                    add = NO;
                    break;
                } else if ([value intValue] < [[array objectAtIndex:i] intValue]) {
                    [array insertObject:value atIndex:i];
                    add = NO;
                    break;
                }
            }
            if (add) {
                [array addObject:value];
            }
        } else {
            for (NSInteger j = 0; j < [array count]; j++) {
                if ([value intValue] > [[array objectAtIndex:j] intValue]) {
                    if (j == [array count] - 1) {
                        [array addObject:value];
                        [array removeObjectAtIndex:0];
                    } else {
                        if ([value intValue] < [[array objectAtIndex:j + 1] intValue]) {
                            [array insertObject:value atIndex:j + 1];
                            [array removeObjectAtIndex:0];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    for (NSInteger i = [array count] - 1; i >= 0; i--) {
        if ([[array objectAtIndex:i] intValue] == 0) {
            [array removeObjectAtIndex:i];
        }
    }
    
    //布局
    [self setStatisLabel:statistics topArray:array maxOperator:[NSNumber numberWithInteger:maxOperator]];
}

- (void)setStatisLabel:(NSArray *)statistics topArray:(NSArray *)array maxOperator:(NSNumber *)maxOperator {
    for (NSInteger i = 0; i < 14; i++) {
        NSArray *tempArray = array;
        CGPoint orgin = CGPointMake(0, 0);
        if (i >= 0 && i < 4) {
            orgin = CGPointMake(160, i * 74 + 160);
            tempArray = [NSArray arrayWithObjects:maxOperator, nil];
        } else if (i >= 4 && i < 9) {
            orgin = CGPointMake(470, (i - 4) * 54 + 156);
        } else {
            orgin = CGPointMake(780, (i - 9) * 55 + 158);
        }
        
        UILabel *number = (UILabel *)[_backgroundV viewWithTag:1000 + i];
        NSString *text = [KenUtils isEmpty:statistics] ? @"" : [NSString stringWithFormat:@"%d", [[statistics objectAtIndex:i] intValue]];
        if (number) {
            number.text = text;
            [number setTextColor:[self containNumber:[statistics objectAtIndex:i] array:tempArray] ? [UIColor redColor] : [UIColor blackColor]];
        } else {
            number = [KenUtils labelWithTxt:text
                                      frame:(CGRect){orgin, 140, 50} font:[UIFont boldSystemFontOfSize:38]
                                      color:[self containNumber:[statistics objectAtIndex:i] array:tempArray] ? [UIColor redColor] : [UIColor blackColor]];
            number.tag = 1000 + i;
            [_backgroundV addSubview:number];
        }
    }
}

- (BOOL)containNumber:(NSNumber *)number array:(NSArray *)array {
    for (NSNumber *value in array) {
        if ([value intValue] == [number intValue] && [value intValue] != 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - button
- (void)customBtnClicked:(UIButton *)button {
    if (_calendarV) {
        [_calendarV removeFromSuperview];
        _calendarV = nil;
    }
    
    _calendarV = [[UIView alloc] initWithFrame:(CGRect){0, 0, self.size}];
    [_calendarV setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4]];
    [self addSubview:_calendarV];
    
    //tap gesture
    UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelCalendar:)];
    tapTouch.delegate = self;
    [_calendarV addGestureRecognizer:tapTouch];
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc] initWithParentFrame:(CGRect){0, 0, self.size}];
    calendar.tag = 9999;
    calendar.delegate = self;
    [_calendarV addSubview:calendar];
    
    _labelFast.text = NSLocalizedString(@"statisticsFastSel", nil);
}

- (void)fastBtnClicked:(UIButton *)button {
    [_fastSelectV setHidden:NO];
    
    _labelFast.text = NSLocalizedString(@"statisticsFastSel", nil);
}

- (void)selectBtnClicked:(UIButton *)button {
    NSInteger days = button.tag - 1;
    _dateStart = [KenUtils getStringFromDate:[KenUtils getDateFromDate:[NSDate date] day:-days] format:kDateFormat];
    _dateEnd = [KenUtils getStringFromDate:[NSDate date] format:kDateFormat];
    _labelDate.text = [NSString stringWithFormat:@"%@ - %@", _dateStart, _dateEnd];
    
    _labelFast.text = button.titleLabel.text;
    
    [self setDataUI:[[UserModel sharedInstance] getTongJiData:days from:nil to:nil]];
    
    [_fastSelectV setHidden:YES];
    [_backgroundV bringSubviewToFront:_fastSelectV];
}

#pragma mark - gesture
- (void)cancelCalendar:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    UIView *view = [_calendarV viewWithTag:9999];
    if (view && !CGRectContainsPoint(view.frame, point)) {
        [_calendarV removeFromSuperview];
        _calendarV = nil;
    }
}

- (void)cancelFastSelect:(UITapGestureRecognizer *)gesture {
    if (![_fastSelectV isHidden]) {
        [_fastSelectV setHidden:YES];
    }
}

#pragma mark VRGCalendarViewDelegate methods
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}

- (void)calendarViewFinishSelect:(VRGCalendarView *)calendarView startDate:(NSDate *)start endDate:(NSDate *)end{
    if ([KenUtils isEmpty:start]) {
        start = [NSDate date];
    }
    if ([KenUtils isEmpty:end]) {
        end = start;
    }
    _dateStart = [start dateStringWithFormat:kDateFormat];
    _dateEnd = [end dateStringWithFormat:kDateFormat];
    _labelDate.text = [NSString stringWithFormat:@"%@ - %@", _dateStart, _dateEnd];
    [self setDataUI:[[UserModel sharedInstance] getTongJiData:0 from:_dateStart to:_dateEnd]];
    
    [_calendarV removeFromSuperview];
    _calendarV = nil;
}
@end
