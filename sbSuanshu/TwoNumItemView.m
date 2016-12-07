//
//  2NumItemView.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-16.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "TwoNumItemView.h"

@implementation TwoNumItemView

@synthesize labelResult;
@synthesize labelNo;
@synthesize labelQuestion;
@synthesize imgViewCorret;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (TwoNumItemView*)create
{
    TwoNumItemView *view;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TwoNumItemView"
                                                 owner:nil options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:[TwoNumItemView class]])
        {
            view = (TwoNumItemView *)oneObject;
//            view.backgroundColor = [UIColor clearColor];
            break;
        }
    }
    
    return view;
    
}
@end
