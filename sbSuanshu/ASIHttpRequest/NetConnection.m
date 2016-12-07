//
//  NetConnection.m


#import "NetConnection.h"
//#import "JSONKit.h"





static NetConnection* _net1 = nil;

@implementation NetConnection
@synthesize flag;

#pragma mark private
-(id)init{
	if (self = [super init])
	{
        queue = [[ASINetworkQueue alloc] init];
        [queue setShouldCancelAllRequestsOnFailure:NO];
        [queue setMaxConcurrentOperationCount:1];
        
        
	}
	return self;
}


-(void)dealloc{
	
    [queue release];
    [super dealloc];
}



+ (NetConnection*)getNetConnection{
    if (_net1 == nil) {
        _net1 = [[NetConnection alloc]init];
    }
    return _net1;
}




#pragma mark request method

-(void)postFileData:(NSData *)FileData Req:(id)request  delegate:(id)user withTag:(int)tag
{
    
     /*for (ASIHTTPRequest *curItem in [queue operations])
     {
         id curUser = nil;
         
         curUser = [curItem.userInfo objectForKey:@"delegate"];
         if ((user == curUser)  && (tag == curItem.tag))
         {
             return ;
         }
     }
    
    notResponseYet = YES;
    
	dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SERVERADDR]];
    dataRequest.tag = tag;

    [dataRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,@"delegate",nil]];
    
    
    NSString* action = nil;
    
    
    switch (tag) 
    {
            //商户
            
            //好友
        case REQUEST_TAG_HAOYOU_UPLOAD_PIC :
            action = @"MediaUpload";
            [dataRequest addData:FileData withFileName:@"1.jpeg" andContentType:@"image/jpeg" forKey:@"mediabytes" ];
            break;
        case REQUEST_TAG_HAOYOU_UPLOAD_VOICE :
            action = @"MediaUpload";
            [dataRequest addData:FileData withFileName:@"1.aac" andContentType:@"audio/aac" forKey:@"mediabytes" ];
            break;
            
            //个人  
            case REQUEST_TAG_GEREN_ADDPHOTO :
            action = @"AddPhoto";
            [dataRequest addData:FileData withFileName:@"1.jpeg" andContentType:@"image/jpeg" forKey:@"photobytes" ];
            break;

            //更多
            
            default:
            break;
    }
    

    
    [dataRequest addPostValue:action forKey:@"Action"];
    if (nil != request)
    {
            [dataRequest addPostValue:[request toJSON] forKey:@"PostData"];
    }

	[dataRequest setTimeOutSeconds:15.0];
	[dataRequest setDelegate:self];
    [queue addOperation:dataRequest];
    [queue go];*/
    

}






-(void)postRequest:(id)request  delegate:(id)user withTag:(int)tag
{
    
    for (ASIHTTPRequest *curItem in [queue operations])
    {
        id curUser = nil;
        
        curUser = [curItem.userInfo objectForKey:@"delegate"];
        if ((user == curUser)  && (tag == curItem.tag))
        {
            return ;
        }
    }
    
    notResponseYet = YES;
    
	dataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SERVERADDR]];
    dataRequest.tag = tag;
    
    [dataRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,@"delegate",nil]];

    [dataRequest addPostValue:NET_APPID forKey:@"app_id"];
    
	[dataRequest setTimeOutSeconds:15.0];
	[dataRequest setDelegate:self];
    
    [queue addOperation:dataRequest];
    [queue go];
    
    
}


-(void)cancelDataRequest:(id)user withTag:(int)tag
{
    for (ASIHTTPRequest *curItem in [queue operations])
    {
        id curUser = nil;
        
        curUser = [curItem.userInfo objectForKey:@"delegate"];
        if ((user == curUser)  && (tag == curItem.tag))
        {
            [curItem cancel];
            curItem.userInfo = nil;
            curItem.delegate = nil;
            return ;
        }
    }
    return;
}



-(void)cancelDelegateDataRequest:(id)user
{
    
    for (ASIHTTPRequest *curItem in [queue operations])
    {
        id curUser = nil;
        
        curUser = [curItem.userInfo objectForKey:@"delegate"];
        if (user == curUser) 
        {
            [curItem cancel];
            curItem.userInfo = nil;
            curItem.delegate = nil;
        }
    }
    
}

-(void)cancelAllDataRequest
{
    for (ASIHTTPRequest *curItem in [queue operations])
    {
        [curItem cancel];
        curItem.userInfo = nil;
        curItem.delegate = nil;
    }
}



// get method
-(void)getDatafromServer:(NSString *)server delegate:(id)user withTag:(int)tag
{
    
    for (ASIHTTPRequest *curItem in [queue operations])
    {
        id curUser = nil;
        
        curUser = [curItem.userInfo objectForKey:@"delegate"];
        if ((user == curUser)  && (tag == curItem.tag))
        {
            return ;
        }
    }
    
	NSURL *url = [NSURL URLWithString:server]; 
	ASIHTTPRequest *dataRequest = [ASIHTTPRequest requestWithURL:url];
    dataRequest.tag = tag;
	dataRequest.delegate = self;
    [dataRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,@"delegate",nil]];
    
    [queue addOperation:dataRequest];
    [queue go];
    
	//[httpRequest startSynchronous];

}

-(void)getImage:(NSString *)imgURL savePath:(NSString *)path delegate:(id)user withTag:(int)tag
{
    NSURL *url = [NSURL URLWithString:imgURL];
    ASIHTTPRequest *dataRequest = [ASIHTTPRequest requestWithURL:url];
    dataRequest.tag = tag;
    [dataRequest setDownloadDestinationPath:path];
    
    
    [dataRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,@"delegate",nil]];
	[dataRequest setTimeOutSeconds:15.0];
	[dataRequest setDelegate:self];
    
    [queue addOperation:dataRequest];
    [queue go];
}

#pragma mark ASIHTTPRequestDelegate
- (void) requestFinished:(ASIHTTPRequest *)request{
    
    
    NSObject *user = nil;
    
    notResponseYet = NO;

    
    
    user = [request.userInfo objectForKey:@"delegate"];
    if([user respondsToSelector:@selector(theDelegateRequestFinished:)])
    {
        [user performSelector:@selector(theDelegateRequestFinished:) withObject:request];
    }
    request.userInfo = nil;
    request.delegate = nil;
    
       
}

- (void) requestFailed:(ASIHTTPRequest *)request
{    
    notResponseYet = NO;
    NSObject *user = nil;
    
	NSError *error = [request error];
    user = [request.userInfo objectForKey:@"delegate"];
    
    
	if([user respondsToSelector:@selector(theDelagateRequestFailed:)])
	{
        [user performSelector:@selector(theDelagateRequestFailed:) withObject:request];
	}
    
    request.userInfo = nil;
    request.delegate = nil;

    
	
}



@end
