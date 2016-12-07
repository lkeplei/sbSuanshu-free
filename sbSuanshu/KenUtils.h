//
//  KenUtils.h
//  KenRecorder
//
//  Created by 刘坤 on 15/1/21.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <string.h>

@interface KenUtils : NSObject

+ (BOOL)isEmpty:(id)object;
+ (BOOL)isNotEmpty:(id)object;

//获取设备的mac地址
+ (NSString *)getMacAddress;
+ (NSString *)getDeviceModel;
+ (NSString *)getDeviceName;
+ (NSString *)getDeviceSystemVersion;

+ (UIButton*)buttonWithImg:(NSString*)buttonText off:(int)off zoomIn:(BOOL)zoomIn image:(UIImage*)image
                 imagesec:(UIImage*)imagesec target:(id)target action:(SEL)action;

+ (UILabel*)labelWithTxt:(NSString *)buttonText frame:(CGRect)frame
                   font:(UIFont*)font color:(UIColor*)color;

+ (UITextField*)textFieldInit:(CGRect)frame color:(UIColor*)color bgcolor:(UIColor*)bgcolor
                        secu:(BOOL)secu font:(UIFont*)font text:(NSString*)text;

+ (const CGFloat*)getRGBAFromColor:(UIColor*)color;

+ (void)showRemindMessage:(NSString*)message;

+ (NSNumber*)getNumberByBool:(BOOL)value;
+ (NSNumber*)getNumberByInt:(int)value;

+ (NSString*)getStringByStdString:(const char*)string;
+ (NSString*)getStringByInt:(int)number;
+ (NSString*)getStringByFloat:(float)number decimal:(int)decimal;

+ (void)openUrl:(NSString*)url;

+ (NSString*)getAppVersion;
+ (NSString*)getAppName;

+ (void)callPhoneNumber:(NSString*)number view:(UIView*)view;

+ (CGSize)getFontSize:(NSString*)text font:(UIFont*)font;
+ (NSArray*)getArrayFromStrByCharactersInSet:(NSString*)strResource character:(NSString*)character;

+ (NSString*)getTimeString:(double)time format:(NSString*)format second:(BOOL)second;
+ (NSDate*)getDateFromString:(NSString*)time format:(NSString*)format;
+ (NSString*)getStringFromDate:(NSDate*)date format:(NSString*)format;
+ (NSDate *)getDateFromDate:(NSDate *)date day:(NSInteger)day;
+ (NSDateComponents*)getComponentsFromDate:(NSDate*)date;
+ (NSDateComponents*)getSubFromTwoDate:(NSDate*)from to:(NSDate*)to;
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

+ (NSString*)getFilePathInDocument:(NSString*)fileName;

//编码转换
//gb2312 - utf8
+ (CFStringRef)EncodeUTF8Str:(NSString *)encodeStr;
//uft8-----gb2312
+ (NSString *)EncodeGB2312Str:(NSString *)encodeStr;

//打电话发邮件
+ (void) makeCall:(NSString *)phoneNumber msg:(NSString *)msg;
+ (void) sendSms:(NSString *)phoneNumber msg:(NSString *)msg;
+ (void) sendEmail:(NSString *)phoneNumber;
+ (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;

//file
+ (unsigned long long)getFileSize:(NSString*)filePath;
+ (unsigned long long)getFolderSize:(NSString*)folderPath;
+ (BOOL)deleteFileWithPath:(NSString*)path;
+ (BOOL)fileExistsAtPath:(NSString*)path;
+ (BOOL)createFolderAtPath:(NSString *)path;

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;

//voice
+ (float)getCurrentVoice;
+ (void)setVoice:(float)value;

//获取时间 from  length         00:00:00
+ (NSString *)getTimeString:(NSInteger)length;

//设置设备横竖屏
+ (void)setOrientation:(UIInterfaceOrientation)orientation;

/**
 *  @author Ken.Liu
 *
 *  @brief  设置系统音量
 *
 *  @param value 音量大小值（0-1）
 */
+ (void)setSysVOlueVoice:(float)value;

/**
 *  @author Ken.Liu
 *
 *  @brief  获取当前系统音量
 *
 *  @return 返回音量 （0-1）
 */
+ (float)getSysVolumeVoice;

/**
 *  @author Ken.Liu
 *
 *  @brief  获取当前手机连接wifi（SSID）
 *
 *  @return 返回SSID
 */
+ (NSString *)getCurrentSSID;

/**
 *  @author Ken.Liu
 *
 *  @brief  判断是否为合法的镜头wifi
 *
 *  @return YES为合法，NO为不合法
 */
+ (BOOL)validateIPCAM:(NSString *)ssid;

#pragma mark - 获取局域网ip
+ (NSString *)localIPAddress;
@end