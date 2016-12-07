//
//  NetConnection.h


#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "ASIHTTPRequestConfig.h"
#import "ASICacheDelegate.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"
#import "ASIAuthenticationDialog.h"
#import "ASIInputStream.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"

#define CACHE_KEY_CONTROL  @"control"
#define CACHE_KEY_1  @"1"
#define CACHE_KEY_2  @"2"
#define CACHE_KEY_3  @"3"
#define CACHE_KEY_4  @"4"
#define CACHE_KEY_5  @"5"
#define CACHE_KEY_6  @"6"
#define CACHE_KEY_7  @"7"
#define CACHE_KEY_8  @"8"
#define CACHE_KEY_9  @"9"
#define CACHE_KEY_10  @"10"


#define REQUEST_TAG_ALLCHANGE     1000
#define REQUEST_TAG_FRISTPAGE_BGIMAGE 1001



#define REQUEST_TAG_OTHER     5000

#define NET_APPID @"1"

#define NET_IMAGEKEY @"image"
#define NET_TITLEKEY @"title"
#define NET_SUBTITLEKEY @"sub_title"
#define NET_MIAOSHUKEY @"detail_text"


#define FIRPAGE_LISTNAME @"firstpage.plist"



//用户名:test1,密码:test1.
#define IMAGE_HEADER @"http://111.1.46.125/ziniu/server/www/uploads/"

//配置网址:@"http://111.1.46.125/ziniu/server/edit_ipad"
#define SERVERADDR @"http://111.1.46.125/ziniu/server/jsonapi"





#define APP_DOCUMENTS @"/Documents/"



@class NetConnection;
@protocol NetConnectionDelegate<NSObject>
@optional
-(void)theDelegateRequestFinished:(ASIHTTPRequest *)request;
-(void)theDelagateRequestFailed:(ASIHTTPRequest *)request;
-(void)theDelegateRequestFinished:(ASIHTTPRequest *)request withResponse:(id)response;
@end


@interface NetConnection : NSObject {
	int flag;
    ASIFormDataRequest *dataRequest;
    ASINetworkQueue *queue;
    BOOL notResponseYet;
	
}

@property(nonatomic,assign) int flag;


-(void)postFileData:(NSData *)FileData Req:(id)request  delegate:(id)user withTag:(int)tag;

-(void)getDatafromServer:(NSString *)server delegate:(id)user withTag:(int)tag ;

-(void)cancelDelegateDataRequest:(id)user;
//cancel
-(void)cancelDataRequest:(id)user withTag:(int)tag;

-(void)cancelAllDataRequest;

-(void)postRequest:(id)request  delegate:(id)user withTag:(int)tag;

-(void)getImage:(NSString *)imgURL savePath:(NSString *)path delegate:(id)user withTag:(int)tag;


+ (NetConnection*)getNetConnection;

@end
