//
//  ECPurchase.m
//  myPurchase
//
//  Created by ris on 10-4-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ECPurchase.h"
#import "SBJSON.h"
#import "GTMBase64.h"

/******************************
 SKProduct extend
 *****************************/
@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    [numberFormatter release];
    return formattedString;
}

@end

/***********************************
 ECPurchaseHTTPRequest
 ***********************************/
@implementation ECPurchaseHTTPRequest
@synthesize productIdentifier = _productIdentifier;

@end

/******************************
 ECPurchasex
 ******************************/
@implementation ECPurchase
@synthesize productDelegate = _productDelegate;
@synthesize transactionDelegate =_transactionDelegate;
@synthesize verifyRecepitMode = _verifyRecepitMode;

SINGLETON_IMPLEMENTATION(ECPurchase);

//you can init the object here as the object init is in SINGLETON_IMPLEMENTATION
-(void)postInit
{
	_verifyRecepitMode = ECVerifyRecepitModeNone;
	[self registerNotifications];
}

- (void)requestProductData:(NSArray *)proIdentifiers{
	NSSet *sets = [NSSet setWithArray:proIdentifiers];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:sets];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

-(void) cancelProductRequest
{
    if (_productsRequest)
    {
        [_productsRequest cancel];
    }
}



#pragma mark -
#pragma mark SKProductsRequestDelegate methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
#ifdef ECPURCHASE_TEST_MODE	
	NSMutableString *result = [[NSMutableString alloc] init];
	for (int i = 0; i < [products count]; ++i) {
		SKProduct *proUpgradeProduct = [products objectAtIndex:i];
		[result appendFormat:@"%@,%@,%@,%@\n",
		 proUpgradeProduct.localizedTitle,proUpgradeProduct.localizedDescription,proUpgradeProduct.price,proUpgradeProduct.productIdentifier];
	}
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
		[result appendFormat:@"Invalid product id: %@",invalidProductId];
    }
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iap" message:result
										delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[_productDelegate didReceivedProducts:products];
#else
	[_productDelegate didReceivedProducts:products];

#endif   
	[_productsRequest release];
    _productsRequest = nil;
}

-(void)addTransactionObserver{
	_storeObserver = [[ECStoreObserver alloc] init];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:_storeObserver];
}

-(void)removeTransactionObserver{
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:_storeObserver];
}

-(void)addPayment:(SKProduct *)product userID:(NSInteger)userID exchangeID:(NSString *)exChangID
{
    _userID = userID;
    _exchangeID = [exChangID retain];
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
    //[self verifyServerReceipt:nil];
}


#pragma mark -
#pragma mark NSNotificationCenter Methods
-(void)completeTransaction:(NSNotification *)note{
	SKPaymentTransaction *trans = [[note userInfo] objectForKey:@"transaction"];
	if (_verifyRecepitMode == ECVerifyRecepitModeNone) {
		[_transactionDelegate didCompleteTransaction:trans.payment.productIdentifier];
	}
	else if(_verifyRecepitMode == ECVerifyRecepitModeiPhone){
		[self verifyReceipt:trans];
	}
	else if(_verifyRecepitMode == ECVerifyRecepitModeServer){
        [self verifyServerReceipt:trans];
	}
	
}

-(void)failedTransaction:(NSNotification *)note{
	SKPaymentTransaction *trans = [[note userInfo] objectForKey:@"transaction"];
    int code=[trans.error code];
	if (code != SKErrorPaymentCancelled)
    {
        NSString *title=nil;
        if ([trans.error code]==SKErrorPaymentInvalid) {
            NSLog(@"SKErrorPaymentInvalid");
            title=@"SKErrorPaymentInvalid";
        }else if ([trans.error code]==SKErrorPaymentNotAllowed) {
            NSLog(@"SKErrorPaymentNotAllowed");
            title=@"SKErrorPaymentNotAllowed";
        }else if ([trans.error code]==SKErrorClientInvalid) {
            NSLog(@"SKErrorClientInvalid");
            title=@"SKErrorClientInvalid";
        }else if ([trans.error code]==SKErrorUnknown) {
            NSLog(@"SKErrorUnknown");
            title=@"SKErrorUnknown";
        }else {
            NSLog(@"SKError");
            title=@"SKError";
        }
//        title=@"Error";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:[trans.error localizedDescription]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        // Optionally, display an error here.
    }
    [_transactionDelegate didFailedTransaction:trans.payment.productIdentifier];    
}

-(void)registerNotifications{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeTransaction:) name:@"completeTransaction" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedTransaction:) name:@"failedTransaction" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishRestoreTransaction:) name:@"finishRestoreTransaction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedRestoreTransaction:) name:@"failedRestoreTransaction" object:nil];
}

//for restore.
-(void)finishRestoreTransaction:(NSNotification *)note{
	[_transactionDelegate didRestoreTransaction:nil];
}

-(void)failedRestoreTransaction:(NSNotification *)note{
    NSError *error = [[note userInfo] objectForKey:@"error"];
	[_transactionDelegate didFailedRestoreTransaction:error];
}

-(void)verifyReceipt:(SKPaymentTransaction *)transaction
{
    NSLog(@"verifyReceipt.");
	_networkQueue = [ASINetworkQueue queue];
	[_networkQueue retain];
	NSURL *verifyURL = [NSURL URLWithString:STORE_RECEIPTS_URL];
    
	ECPurchaseHTTPRequest *request = [[ECPurchaseHTTPRequest alloc] initWithURL:verifyURL];
	[request setProductIdentifier:transaction.payment.productIdentifier];
	[request setRequestMethod: @"POST"];
	[request setDelegate:self];
    [request setDidFinishSelector:@selector(didFinishVerify:)];

	[request addRequestHeader: @"Content-Type" value: @"application/json"];

	NSString *recepit = [GTMBase64 stringByEncodingData:transaction.transactionReceipt];
    
    
	NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:recepit, @"receipt-data", nil];
	SBJsonWriter *writer = [SBJsonWriter new];
	[request appendPostData: [[writer stringWithObject:data] dataUsingEncoding: NSUTF8StringEncoding]];
	[writer release];
	[_networkQueue addOperation: request];
	[_networkQueue go];
 
    
    
}

-(void)verifyServerReceipt:(SKPaymentTransaction *)transaction
{
    //@Tom test for  no server value.
    NSLog(@"verifyServerReceipt start.");
    
	_networkQueue = [ASINetworkQueue queue];
	[_networkQueue retain];
	NSURL *verifyURL = [NSURL URLWithString:SERVER_RECEIPTS_URL];
	ECPurchaseHTTPRequest *request = [[ECPurchaseHTTPRequest alloc] initWithURL:verifyURL];
	[request setProductIdentifier:transaction.payment.productIdentifier];//transaction.payment.productIdentifier
	[request setRequestMethod: @"POST"];
	[request setDelegate:self];
    [request setDidFinishSelector:@selector(didFinishServerVerify:)];
    
    NSString *recepit = [GTMBase64 stringByEncodingData:transaction.transactionReceipt];
    [request addPostValue:recepit forKey:@"PostData"];
    
    [request addPostValue:[NSString stringWithFormat:@"%d",_userID] forKey:@"UserID"];
    [request addPostValue:[NSString stringWithFormat:@"%@",_exchangeID] forKey:@"ExchangeID"];
	
    [_networkQueue addOperation: request];
	[_networkQueue go];
    
    NSLog(@"verifyServerReceipt end");
    
    
    
}

-(void)didFinishVerify:(ECPurchaseHTTPRequest *)request
{
	NSString *response = [request responseString];
	SBJsonParser *parser = [SBJsonParser new];
	NSDictionary* jsonData = [parser objectWithString: response];
	[parser release];
	NSString *status = [jsonData objectForKey: @"status"];
	if ([status intValue] == 0) {
		NSDictionary *receipt = [jsonData objectForKey: @"receipt"];
		NSString *productIdentifier = [receipt objectForKey: @"product_id"];
		[_transactionDelegate didCompleteTransactionAndVerifySucceed:productIdentifier];
	}
	else {
		NSString *exception = [jsonData objectForKey: @"exception"];
		[_transactionDelegate didCompleteTransactionAndVerifyFailed:request.productIdentifier withError:exception];
	}

}

-(void)didFinishServerVerify:(ECPurchaseHTTPRequest *)request
{
    NSLog(@"didFinishServerVerify");
    
	NSString *response = [request responseString];
    
    if([response isEqualToString:@"success"])
    {
        [_transactionDelegate didCompleteTransactionAndVerifySucceed:request.productIdentifier];
    }
    else
    {
        [_transactionDelegate didCompleteTransactionAndVerifyFailed:request.productIdentifier withError:response];
    }
    
#if 0
	SBJsonParser *parser = [SBJsonParser new];
	NSDictionary* jsonData = [parser objectWithString: response];
	[parser release];
	NSString *status = [jsonData objectForKey: @"status"];
	if ([status intValue] == 0) {
		NSDictionary *receipt = [jsonData objectForKey: @"receipt"];
		NSString *productIdentifier = [receipt objectForKey: @"product_id"];
		[_transactionDelegate didCompleteTransactionAndVerifySucceed:productIdentifier];
	}
	else {
		NSString *exception = [jsonData objectForKey: @"exception"];
		[_transactionDelegate didCompleteTransactionAndVerifyFailed:request.productIdentifier withError:exception];
	}
#endif
}

#pragma mark -
#pragma mark Get Property From ECStoreObserver
-(NSMutableArray *)getCompleteTrans{
	return _storeObserver.completeTrans;
}

-(NSMutableArray *)getRestoreTrans{
	return _storeObserver.restoreTrans;
}

-(NSMutableArray *)getFailedTrans{
	return _storeObserver.failedTrans;
}

-(void)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)dealloc
{
	RELEASE_SAFELY(_networkQueue);
	RELEASE_SAFELY(_storeObserver);
	[super dealloc];
}

@end