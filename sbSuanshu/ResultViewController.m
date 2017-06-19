//
//  ResultViewController.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultTableCell.h"

#import "UserModel.h"

#import "UserViewController.h"

#import "FDGraphView.h"
#import "FDGraphScrollView.h"

#import "AppDelegate.h"
#import "InAppPurchaseManager.h"

#import "MyWrongV.h"
#import "WrongStatisticsV.h"

#import "KenView.h"


#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface ResultViewController () <UITableViewDataSource, UserViewControllerDelegate, InAppPurchaseManagerDelegate,
                                    BaiduMobAdViewDelegate>
{
    NSMutableArray* _historyArray;  //倒序
    NSMutableArray* _historyArrayNormal;    //week value
    UIPopoverController* _popController;
}

@property (nonatomic, strong) UIButton *myWrongBtn;
@property (nonatomic, strong) UIButton *wrongBtn;
@property (nonatomic, strong) UIImageView *secondBg;
@property (nonatomic, strong) MyWrongV *myWrongView;
@property (nonatomic, strong) WrongStatisticsV *wrongStatView;

@property (nonatomic, strong) KenView *kenView;

@property (nonatomic, strong) BaiduMobAdView *sharedAdView;

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    
    //倒序
    _historyArray = [NSMutableArray array];
    NSArray* tmp = [[UserModel sharedInstance]historyResultForCurrentUser];
    _historyArrayNormal = [NSMutableArray arrayWithArray:[[UserModel sharedInstance] weekResultForCurrentUser]];
    
    for (NSInteger i = [tmp count]; i > 0; i--) {
        [_historyArray addObject:[tmp objectAtIndex:(i-1)]];
    }
    
    [btnUser setTitle:[[[UserModel sharedInstance]currentUser] objectForKey:KEY_USER_name] forState:(UIControlStateNormal)];

    if ([(AppDelegate*)[UIApplication sharedApplication].delegate bFreeVersion]) {
//广告初始
        [self.view addSubview:self.sharedAdView];

        [self setBtnForFreeVersion];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnForFreeVersion) name:sb_notify_purchase_ok object:nil];
    }
    
    //新加的部分
    _myWrongBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"result_my_wrong_sec"]
                                          imagesec:[UIImage imageNamed:@"result_my_wrong"]
                                            target:self action:@selector(myWrongBtnClicked)];
    _myWrongBtn.origin = CGPointMake(CGRectGetMaxX(_btnTongji.frame) + 40, _btnTongji.originY);
    [self.view addSubview:_myWrongBtn];
    
    _wrongBtn = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"result_wrong_sec"]
                                        imagesec:[UIImage imageNamed:@"result_wrong"]
                                          target:self action:@selector(wrongBtnClicked)];
    _wrongBtn.origin = CGPointMake(CGRectGetMaxX(_myWrongBtn.frame) + 40, _myWrongBtn.originY);
    [self.view addSubview:_wrongBtn];
    
    _secondBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.6.png"]];
    _secondBg.origin = _imgViewBg.origin;
    [self.view addSubview:_secondBg];
    [_secondBg setUserInteractionEnabled:YES];
    [_secondBg setHidden:YES];
    
    viewChart.center = CGPointMake(_secondBg.width / 2, _secondBg.height / 2);
    [_secondBg addSubview:viewChart];
    
    _myWrongView = [[MyWrongV alloc] initWithFrame:(CGRect){_imgViewBg.origin, _imgViewBg.size}];
    [self.view addSubview:_myWrongView];
    [_myWrongView setHidden:YES];
    
    _wrongStatView = [[WrongStatisticsV alloc] initWithFrame:(CGRect){_imgViewBg.origin, _imgViewBg.size}];
    [self.view addSubview:_wrongStatView];
    [_wrongStatView setHidden:YES];
    
    //线图
    _kenView = [[KenView alloc] initWithFrame:CGRectMake(0, 4, 820, 380)];
    [_kenView setBackgroundColor:[UIColor clearColor]];
    [viewChart insertSubview:_kenView atIndex:0];
#if 1
    [_kenView setDataPoint:_historyArrayNormal];
#else
    [_kenView setDataPoint:@[@{KEY_week_number:[KenUtils getDateFromString:@"2014.05.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@100},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2014.06.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@180},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2014.07.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@60},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2014.08.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@40},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2014.09.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@300},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2014.11.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@234},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2014.12.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@599},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.01.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@322},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.03.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@227},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.04.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@120},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.05.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@89},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.08.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@326},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.09.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@227},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.11.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@120},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2015.12.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@83},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2016.05.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@270},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2016.06.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@379},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2016.07.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@120},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2016.08.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@963},
                         @{KEY_week_number:[KenUtils getDateFromString:@"2016.09.12" format:@"yyyy.MM.dd"], KEY_week_zonghe:@82}]];
#endif
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark UITableViewDelegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_historyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultTableCell";
    
    ResultTableCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ResultTableCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary* item = [_historyArray objectAtIndex:indexPath.row];
    cell.labelDate.text = [self formatDate:[item objectForKey:KEY_History_date]];
    NSMutableString* s1 = [NSMutableString string];
    int iTixing = [[item objectForKey:KEY_History_fuhao]intValue];
    if (1&iTixing) {
        [s1 appendString:@"+ "];
    }
    if (2&iTixing) {
        [s1 appendString:@"- "];
    }
    if (4&iTixing) {
        [s1 appendString:@"× "];
    }
    if (8&iTixing) {
        [s1 appendString:@"÷"];
    }
    int iMode = [[item objectForKey:KEY_History_mode]intValue];
    if (2 == iMode) {
        [s1 appendString:@"\n"];
        [s1 appendString:NSLocalizedString(@"mode1", nil)];
    }
    else if (3 == iMode) {
        [s1 appendString:@"\n"];
        [s1 appendString:NSLocalizedString(@"mode2", nil)];
    }
    if (10 == iMode) {
        [s1 appendString:@"\n"];
        [s1 appendString:NSLocalizedString(@"mode3", nil)];
    }
    cell.labelTixing.text = s1;
    cell.labelTishu.text = [NSString stringWithFormat:@"%@", [item objectForKey:KEY_History_cnt]];
    int t1 = [[item objectForKey:KEY_History_duration]intValue];
    int m = t1/60;
    int s = (int)t1%60;
    cell.labelYongshi.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
    cell.labelDefen.text = [NSString stringWithFormat:@"%@", [item objectForKey:KEY_History_defen]];
    cell.imgViewStar1.highlighted = NO;
    cell.imgViewStar2.highlighted = NO;
    cell.imgViewStar3.highlighted = NO;
    cell.imgViewStar4.highlighted = NO;
    cell.imgViewStar5.highlighted = NO;
    cell.imgViewStar6.highlighted = NO;
    float fDifficulty = [[item objectForKey:KEY_History_nandu]floatValue];
    if (fDifficulty < 2.0) {
        cell.imgViewStar1.highlighted = YES;
    }
    else if (fDifficulty < 3.0) {
        cell.imgViewStar1.highlighted = YES;
        cell.imgViewStar2.highlighted = YES;
    }
    else if (fDifficulty < 4.0) {
        cell.imgViewStar1.highlighted = YES;
        cell.imgViewStar2.highlighted = YES;
        cell.imgViewStar3.highlighted = YES;
    }
    else if (fDifficulty < 5.0) {
        cell.imgViewStar1.highlighted = YES;
        cell.imgViewStar2.highlighted = YES;
        cell.imgViewStar3.highlighted = YES;
        cell.imgViewStar4.highlighted = YES;
    }
    else if (fDifficulty < 6.0) {
        cell.imgViewStar1.highlighted = YES;
        cell.imgViewStar2.highlighted = YES;
        cell.imgViewStar3.highlighted = YES;
        cell.imgViewStar4.highlighted = YES;
        cell.imgViewStar5.highlighted = YES;
    }
    else {
        cell.imgViewStar1.highlighted = YES;
        cell.imgViewStar2.highlighted = YES;
        cell.imgViewStar3.highlighted = YES;
        cell.imgViewStar4.highlighted = YES;
        cell.imgViewStar5.highlighted = YES;
        cell.imgViewStar6.highlighted = YES;
    }
    cell.labelZonghe.text = [NSString stringWithFormat:@"%@", [item objectForKey:KEY_History_zonghe]];

    
    return cell;
}

#pragma mark action
- (void)myWrongBtnClicked {
    _btnHistory.selected = NO;
    _btnTongji.selected = NO;
    _wrongBtn.selected = NO;
    _myWrongBtn.selected = YES;
    
    _imgViewBg.highlighted = YES;
    _secondBg.hidden = YES;
    _viewHistoryContainer.hidden = YES;
    
    viewChart.hidden = YES;
    _myWrongView.hidden = NO;
    _wrongStatView.hidden = YES;
}

- (void)wrongBtnClicked {
    _btnHistory.selected = NO;
    _btnTongji.selected = NO;
    _wrongBtn.selected = YES;
    _myWrongBtn.selected = NO;
    
    _imgViewBg.highlighted = NO;
    _secondBg.hidden = YES;
    _viewHistoryContainer.hidden = NO;
    
    viewChart.hidden = YES;
    _myWrongView.hidden = YES;
    _wrongStatView.hidden = NO;
}

-(IBAction)btnBackClicked:(UIButton *)btn {
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)btnClicked:(UIButton *)btn {
    if (btn == _btnHistory) {
        _btnHistory.selected = YES;
        _btnTongji.selected = NO;
        _wrongBtn.selected = NO;
        _myWrongBtn.selected = NO;
        
        _imgViewBg.hidden = NO;
        _secondBg.hidden = YES;
        _viewHistoryContainer.hidden = NO;
        
        viewChart.hidden = YES;
        _myWrongView.hidden = YES;
        _wrongStatView.hidden = YES;
    } else if (btn == _btnTongji) {
        if ([self alertForFreeVersion]) {
            return;
        }
        
        _btnHistory.selected = NO;
        _btnTongji.selected = YES;
        _wrongBtn.selected = NO;
        _myWrongBtn.selected = NO;
        
        _imgViewBg.hidden = YES;
        _secondBg.hidden = NO;
        _viewHistoryContainer.hidden = YES;

        viewChart.hidden = NO;
        _myWrongView.hidden = YES;
        _wrongStatView.hidden = YES;
    }
}

#pragma mark private
- (NSString*)formatDate:(NSDate*)date {
    static NSDateFormatter* formatter = nil;
    if (nil == formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/M/d";
    }
    return [formatter stringFromDate:date];
}

#pragma mark lock free version
- (void)setBtnForFreeVersion {
    if ([(AppDelegate*)[UIApplication sharedApplication].delegate bFreeVersion]) {
        
        [_btnTongji setImage:[UIImage imageNamed:@"8.2.png"] forState:(UIControlStateNormal)];
    }
    else {

        [_btnTongji setImage:[UIImage imageNamed:@"2.2.png"] forState:(UIControlStateNormal)];
        
        //取消广告
        [_sharedAdView removeFromSuperview];
        _sharedAdView = nil;
    }
}

- (BOOL)alertForFreeVersion {
    if ([(AppDelegate*)[UIApplication sharedApplication].delegate bFreeVersion]) {
        ssAlertNoTitle(NSLocalizedString(@"Purchase", nil), NSLocalizedString(@"Restore", nil), self);
        return YES;
    }
    else {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 != buttonIndex) {
        NSLog(@"click buy");
        
        [InAppPurchaseManager singleton].delegate = self;
        
        if (2 == buttonIndex) {
            [[InAppPurchaseManager singleton] restore];
        }
        else {
            NSArray *ids = [NSArray arrayWithObject:@"isnowball_math_regular"];
            [[InAppPurchaseManager singleton] requestProductData:ids];
        }
        
    }
}

#pragma mark InAppPurchaseManagerDelegate
-(void)didReceivedProducts:(NSArray *)products
{
    if ([products count] == 0)
    {
        TTAlertNoTitle(@"获取产品信息失败", nil);
        return;
    }
    for(SKProduct *product in products)
    {
        [[InAppPurchaseManager singleton] addPayment:product userID:0 exchangeID:nil];
    }
    
}

//delegate: i show various event in here.
-(void)didFailedTransaction:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseFail", nil), nil);
}

-(void)didCompleteTransaction:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseSuccess", nil), nil);
}


//恢复
-(void)didFailedRestoreTransaction:(NSError *)error
{
    TTAlertNoTitle(NSLocalizedString(@"RestoreFail", nil), nil);
}

-(void)didRestoreTransaction:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"RestoreSuccess", nil), nil);
    [[NSNotificationCenter defaultCenter]postNotificationName:sb_notify_purchase_ok object:nil];
}


//购买
-(void)didCompleteTransactionAndVerifySucceed:(NSString *)proIdentifier
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseSuccess", nil), nil);
    [[NSNotificationCenter defaultCenter]postNotificationName:sb_notify_purchase_ok object:nil];
}

-(void)didCompleteTransactionAndVerifyFailed:(NSString *)proIdentifier withError:(NSString *)error
{
    TTAlertNoTitle(NSLocalizedString(@"PurchaseFail", nil), nil);
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
        UIStoryboardPopoverSegue* ps = (UIStoryboardPopoverSegue*)segue;
        
        UserViewController* c1 = segue.destinationViewController;
        c1.delegate = self;
        
        _popController = ps.popoverController;
    }
}

#pragma mark UserViewControllerDelegate
-(void)didSelectedUser:(NSDictionary*)user
{
    [_popController dismissPopoverAnimated:YES];
    
    [btnUser setTitle:[user objectForKey:KEY_USER_name] forState:(UIControlStateNormal)];
    
    NSDictionary* d1 = [[UserModel sharedInstance]currentUser];
    [[UserModel sharedInstance] setCurrentUser:user];
    //倒序
    _historyArray = [NSMutableArray array];
    NSArray* tmp = [[UserModel sharedInstance] historyResultForCurrentUser];
    _historyArrayNormal = [NSMutableArray arrayWithArray:[[UserModel sharedInstance] weekResultForCurrentUser]];

    for (NSInteger i = [tmp count]; i > 0; i--) {
        [_historyArray addObject:[tmp objectAtIndex:(i-1)]];
    }

    [[UserModel sharedInstance] setCurrentUser:d1];
    
    [_tableView reloadData];
    
    // data
    [_kenView setDataPoint:_historyArrayNormal];
}

#pragma mark UIInterfaceOrientationIsLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - baidu delegate
- (NSString *)publisherId {
    return @"a8ced0f0"; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}

- (BOOL)enableLocation {
    //启用location会有一次alert提示
    return YES;
}

- (void)willDisplayAd:(BaiduMobAdView*)adview {
    NSLog(@"delegate: will display ad");
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason {
    NSLog(@"delegate: failedDisplayAd %d", reason);
}

- (void)didAdImpressed {
    NSLog(@"delegate: didAdImpressed");
    
}

- (void)didAdClicked {
    NSLog(@"delegate: didAdClicked");
}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
}

#pragma mark - getter setter
- (BaiduMobAdView *)sharedAdView {
    if (_sharedAdView == nil) {
        //lp颜色配置
        [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
        
        //使用嵌入广告的方法实例。
        _sharedAdView = [[BaiduMobAdView alloc] init];
        _sharedAdView.AdUnitTag = @"3609630";
        _sharedAdView.AdType = BaiduMobAdViewTypeBanner;
        CGFloat bannerHeight = 0.1 * kScreenHeight;
        CGFloat offsetX = 0.18 * kScreenHeight;
        _sharedAdView.frame = CGRectMake(offsetX, kScreenHeight - bannerHeight, kScreenWidth - offsetX * 2 , bannerHeight);
        
        _sharedAdView.delegate = self;
        [_sharedAdView start];
    }
    return _sharedAdView;
}

@end
