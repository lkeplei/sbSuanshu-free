//
//  KenView.m
//  sbSuanshu
//
//  Created by 刘坤 on 15/12/25.
//  Copyright © 2015年 hou guanhua. All rights reserved.
//

#import "KenView.h"
#import "UserModel.h"
#import "FDGraphScrollView.h"

static NSInteger nodeNumber = 8;            //y轴节点数

@interface KenView ()

@property (nonatomic, strong) FDGraphScrollView *scrollView;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;

@end

@implementation KenView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //折线图
        //FDGraphScrollView
        _scrollView = [[FDGraphScrollView alloc] initWithFrame:CGRectMake(50, 0, 760, 376)];
        _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width), 0);
        
        [self addSubview:_scrollView];
        
        _maxValue = 0;
        _minValue = 0;
    }
    return self;
}

- (void)setDataPoint:(NSArray *)dataPoint {
    if (dataPoint && [dataPoint count] > 0) {
        NSMutableArray* data = [NSMutableArray array];
        for (NSDictionary* dic1 in dataPoint) {
            [data addObject:[dic1 objectForKey:KEY_week_zonghe]];
        }
        
        _maxValue = [self maxDataValue:data];
        _minValue = [self minDataValue:data];
        
        _scrollView.dataPoints = dataPoint;
        _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width), 0);
        
        [self setNeedsDisplay];
    }
}

- (NSInteger)maxDataValue:(NSArray *)dataPoints {
    if (_maxValue > 0) {
        return _maxValue;
    } else {
        __block NSInteger max = ((NSNumber *)dataPoints[0]).integerValue;
        [dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if ([n integerValue] > max)
                max = [n integerValue];
        }];
        return max;
    }
}

- (NSInteger)minDataValue:(NSArray *)dataPoints {
    if (_minValue > 0) {
        return _minValue;
    } else {
        __block NSInteger min = ((NSNumber *)dataPoints[0]).integerValue;
        [dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if ([n integerValue] < min)
                min = [n integerValue];
        }];
        return min;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGFloat dash[] = {2};
    CGContextSetLineDash (context, 0, dash, 1);
    
    CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);
    
    CGContextSetShouldAntialias(context, YES);
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(40, 0, 28, 100);         //上、左、下、右    这里要和graphView里面一致
    CGFloat offset = (_scrollView.height - edgeInset.top - edgeInset.bottom) / nodeNumber;
//    y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
    
    //text
//    CGFloat offset = self.height / nodeNumber;
    CGFloat offsetV = (_maxValue - _minValue) / nodeNumber;
    CGFloat value = _minValue;
    NSInteger line = 0;
    CGFloat startY = _scrollView.height - edgeInset.bottom + 2;
    while (value < (_maxValue + offsetV)) {
        NSString *valueS = [NSString stringWithFormat:@"%.f", value];
        [valueS drawAtPoint:CGPointMake(0, startY - line * offset - (line == 0 ? 14 : 7)) withFont:[UIFont systemFontOfSize:16]];
        
        line++;
        value += offsetV;
    }

    //line
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4] CGColor]);
    for (NSInteger i = 0; i < line; i++) {
        CGContextMoveToPoint(context, 50, startY - i * offset);
        CGContextAddLineToPoint(context, 810, startY - i * offset);
    }

    CGContextStrokePath(context);
}

@end
