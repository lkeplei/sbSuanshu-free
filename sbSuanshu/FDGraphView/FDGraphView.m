//
//  FDGraphView.m
//  disegno
//
//  Created by Francesco Di Lorenzo on 14/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import "FDGraphView.h"

#import "UserModel.h"

@interface FDGraphView()
{
    NSArray* _fullData;
}
@property (nonatomic, strong) NSNumber *maxDataPoint;
@property (nonatomic, strong) NSNumber *minDataPoint;

@end

@implementation FDGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default values
        _edgeInsets = UIEdgeInsetsMake(40, 0, 28, 100);         //上、左、下、右
//        _dataPointColor = [UIColor whiteColor];
        _dataPointColor = [UIColor blackColor];
        _dataPointStrokeColor = [UIColor blackColor];
        _linesColor = [UIColor grayColor];
        _autoresizeToFitData = NO;
        _dataPointsXoffset = 104.0f;
        self.backgroundColor = [UIColor clearColor];
        
//        self.clipsToBounds = NO;
    }
    return self;
}

- (NSNumber *)maxDataPoint {
    if (_maxDataPoint) {
        return _maxDataPoint;
    } else {
        __block CGFloat max = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue > max)
                max = n.floatValue;
        }];
        return @(max);
    }
}

- (NSNumber *)minDataPoint {
    if (_minDataPoint) {
        return _minDataPoint;
    } else {
        __block CGFloat min = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue < min)
                min = n.floatValue;
        }];
        return @(min);
    }
}

- (CGFloat)widhtToFitData {
    CGFloat res = 0;
    
    if (self.dataPoints.count > 1) {
        res += (self.dataPoints.count - 1)*self.dataPointsXoffset; // space occupied by data points
        res += (self.edgeInsets.left + self.edgeInsets.right) ; // lateral margins;
    }
    
    return res;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // STYLE
    // lines color
    [self.linesColor setStroke];
    // lines width
    CGContextSetLineWidth(context, 3);
    
    // CALCOLO I PUNTI DEL GRAFICO
    NSInteger count = self.dataPoints.count;
    if (count == 0) {
        return;
    }
    CGPoint graphPoints[count];
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    int iValidCnt = 0;
    int iValidIndex = 0;
    
    NSString* lastDateString;
    
    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSNumber *)self.dataPoints[i]).floatValue;
            
            //跳过无效周，value 0
            if (0 != dataPointValue) {

                x = self.edgeInsets.left + (drawingWidth / (count - 1)) * i;
                if (max != min)
                    y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
                else // il grafico si riduce a una retta
                    y = rect.size.height / 2;
            
                //分数 :RGB  255 107 70   日期:RGB 126 134 65
                //横坐标
                [[UIColor colorWithRed:126/255.0f green:134/255.0f blue:65/255.0f alpha:1] setFill];
                CGContextSetTextDrawingMode(context, kCGTextFill);
                NSDate* d1 = [_fullData[i] objectForKey:KEY_week_number];
                
                NSString* date1 = [NSString stringWithFormat:@"%@", [self formatDate:d1] ];
                if (![lastDateString isEqualToString:date1] || 1) {
                    NSString *temp = date1;
                    
                    CGFloat dateX = x;
                    if (i != 0) {
                        date1 = [self getDateStr:date1 preDate:lastDateString];
                        
                        if (date1.length > 5) {
                            dateX -= 38;
                        } else {
                            dateX -= 18;
                        }
                    }
                    lastDateString = temp;
                    [date1 drawAtPoint:(CGPointMake(dateX, self.height - 16)) withFont:([UIFont systemFontOfSize:15])];
                }
                //纵坐标
                [[UIColor colorWithRed:1 green:107/255.0f blue:70/255.0f alpha:1] setFill];
                NSString* value1 = [NSString stringWithFormat:@"%@", [_fullData[i] objectForKey:KEY_week_zonghe]];
                [value1 drawAtPoint:(CGPointMake(x+10, y-30)) withFont:([UIFont systemFontOfSize:22])];
                graphPoints[iValidIndex] = CGPointMake(x, y);
                iValidIndex++;
                iValidCnt++;
            }
        }
    } else if (count == 1) {
        // pongo il punto al centro del grafico
        graphPoints[0].x = drawingWidth/2;
        graphPoints[0].y = drawingHeight/2;
        
        CGFloat x = graphPoints[0].x;
        CGFloat y = graphPoints[0].y;
        //分数 :RGB  255 107 70   日期:RGB 126 134 65
        //横坐标
        [[UIColor colorWithRed:126/255.0f green:134/255.0f blue:65/255.0f alpha:1] setFill];
        CGContextSetTextDrawingMode(context, kCGTextFill);
        NSDate* d1 = [_fullData[0] objectForKey:KEY_week_number];
        
        NSString* date1 = [NSString stringWithFormat:@"%@", [self formatDate:d1]];
        if (![lastDateString isEqualToString:date1] || 1) {
            [date1 drawAtPoint:(CGPointMake(x, self.height - 16)) withFont:([UIFont systemFontOfSize:15])];
            lastDateString = date1;
        }
        
        //纵坐标
        [[UIColor colorWithRed:1 green:107/255.0f blue:70/255.0f alpha:1] setFill];
        NSString* value1 = [NSString stringWithFormat:@"%@", [_fullData[0] objectForKey:KEY_week_zonghe]];
        [value1 drawAtPoint:(CGPointMake(x+10, y-30)) withFont:([UIFont systemFontOfSize:22])];
        graphPoints[iValidIndex] = CGPointMake(x, y);
        iValidCnt++;
    } else {
        return;
    }
    
    // DISEGNO IL GRAFICO
//    CGContextAddLines(context, graphPoints, count);
    if (iValidCnt > 1) {
        CGContextAddLines(context, graphPoints, iValidCnt);
        CGContextStrokePath(context);
    }
    
    // DISEGNO I CERCHI NEL GRANO
//    for (int i = 0; i < count; ++i) {
    for (int i = 0; i < iValidCnt; ++i) {
        CGRect ellipseRect = CGRectMake(graphPoints[i].x-3, graphPoints[i].y-3, 6, 6);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextSetLineWidth(context, 2);
        [self.dataPointStrokeColor setStroke];
        [self.dataPointColor setFill];
        CGContextFillEllipseInRect(context, ellipseRect);
        CGContextStrokeEllipseInRect(context, ellipseRect);
    }
}

- (NSString *)getDateStr:(NSString *)date preDate:(NSString *)preDate {
    if ([[date substringToIndex:4] isEqualToString:[preDate substringToIndex:4]]) {
        return [date substringFromIndex:5];
    } else {
        return date;
    }
}

#pragma mark - Custom setters

- (void)changeFrameWidthTo:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setDataPointsXoffset:(CGFloat)dataPointsXoffset {
    _dataPointsXoffset = dataPointsXoffset;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)setAutoresizeToFitData:(BOOL)autoresizeToFitData {
    _autoresizeToFitData = autoresizeToFitData;
    
    CGFloat widthToFitData = [self widhtToFitData];
    if (widthToFitData > self.frame.size.width) {
        [self changeFrameWidthTo:widthToFitData];
    }
}

- (void)setDataPoints:(NSArray *)dataPoints {
    _fullData = dataPoints;
    NSMutableArray* data = [NSMutableArray array];
    for (NSDictionary* dic1 in _fullData) {
        [data addObject:[dic1 objectForKey:KEY_week_zonghe]];
    }
    _dataPoints = data;

    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.superview.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
        else {
            [self changeFrameWidthTo:self.superview.frame.size.width];
        }
            
    }
    
    [self setNeedsDisplay];
}

#pragma mark - touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"aaaa");
}

#pragma mark private
- (NSString*)formatDate:(NSDate*)date {
    static NSDateFormatter* formatter = nil;
    if (nil == formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd";
    }
    return [formatter stringFromDate:date];
}
@end
