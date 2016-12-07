//
//  ResultTableCell.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-15.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "ResultTableCell.h"

@implementation ResultTableCell

@synthesize labelDate, labelDefen, labelTishu, labelTixing, labelYongshi, labelZonghe,
imgViewStar1, imgViewStar2, imgViewStar3, imgViewStar4, imgViewStar5, imgViewStar6;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
