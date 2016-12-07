//
//  MyWrongV.m
//  sbSuanshu
//
//  Created by 刘坤 on 15/11/27.
//  Copyright © 2015年 hou guanhua. All rights reserved.
//

#import "MyWrongV.h"
#import "UserModel.h"

@interface MyWrongV ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *dataTableV;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MyWrongV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self loadData];
    }
    return self;
}

- (void)initUI {
    UIImageView *bgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"result_my_wrong_bg"]];
    [self addSubview:bgV];
    
    _dataTableV = [[UITableView alloc] initWithFrame:(CGRect){60, 90, self.width - 120, self.height - 90} style:UITableViewStylePlain];
    _dataTableV.delegate = self;
    _dataTableV.dataSource = self;
    _dataTableV.rowHeight = 50;
    _dataTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_dataTableV setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_dataTableV];
}

- (void)loadData {
    NSArray *wrong = [[UserModel sharedInstance] wrongResultForCurrentUser];
    _dataArray = [NSMutableArray array];
    
    for (NSInteger i = [wrong count] - 1; i >= 0; i--) {
        NSDictionary *dic = [wrong objectAtIndex:i];
        NSArray *array = [dic objectForKey:KEY_wrong_data];
        for (NSInteger j = 0; j < [array count]; j++) {
            NSArray *timu = [array objectAtIndex:j];
            
            NSDictionary *one = @{@"date":[dic objectForKey:KEY_wrong_date],
                                  @"timu":[self getTimu:[timu objectAtIndex:1]],
                                  @"rightAnswer":[self getRightAnswer:[timu objectAtIndex:1]],
                                  @"wrongAnser":[NSString stringWithFormat:@"%d", [[timu objectAtIndex:0] intValue]]};
//            [_dataArray addObject:one];
            [_dataArray insertObject:one atIndex:0];
        }
    }
    
    [_dataTableV reloadData];
}

- (NSString *)getRightAnswer:(NSArray *)timu {
    return [NSString stringWithFormat:@"%d", [[timu objectAtIndex:1] intValue]];
}

- (NSString *)getTimu:(NSArray *)timu {
    NSMutableString *result = [NSMutableString string];
    BOOL number = YES;
    for (NSInteger i = 2; i < [timu count]; i++) {
        if (number) {
            [result appendString:[NSString stringWithFormat:@"%d", [[timu objectAtIndex:i] intValue]]];
        } else {
            int iTixing = [[timu objectAtIndex:i] intValue];
            if (iTixing == 1) {
                [result appendString:@" + "];
            } else if (iTixing == 2) {
                [result appendString:@" - "];
            } else if (iTixing == 4) {
                [result appendString:@" × "];
            } else if (iTixing == 8) {
                [result appendString:@" ÷ "];
            } else {
                return @"";
            }
        }
        number = !number;
    }
    
    [result appendString:@" = "];
    
    return result;
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bankCellIdentifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    
    UILabel *date = [KenUtils labelWithTxt:[dic objectForKey:@"date"] frame:(CGRect){0, 0, 120, cell.height}
                                      font:[UIFont boldSystemFontOfSize:22] color:[UIColor blackColor]];
    [cell.contentView addSubview:date];
    
    UILabel *timu = [KenUtils labelWithTxt:[dic objectForKey:@"timu"] frame:(CGRect){150, 0, tableView.width - 470, cell.height}
                                      font:[UIFont boldSystemFontOfSize:34] color:[UIColor blackColor]];
    timu.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timu];
    
    UILabel *wrongAnswer = [KenUtils labelWithTxt:[dic objectForKey:@"wrongAnser"]
                                            frame:(CGRect){CGRectGetMaxX(timu.frame) + 20, 0, 120, cell.height}
                                      font:[UIFont boldSystemFontOfSize:34] color:[UIColor redColor]];
    wrongAnswer.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:wrongAnswer];
    
    UILabel *rightAnswer = [KenUtils labelWithTxt:[dic objectForKey:@"rightAnswer"] frame:(CGRect){tableView.width - 160, 0, 160, cell.height}
                                      font:[UIFont boldSystemFontOfSize:34] color:[UIColor colorWithHexString:@"0x6DC308"]];
    [cell.contentView addSubview:rightAnswer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
