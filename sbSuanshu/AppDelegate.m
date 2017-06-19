//
//  AppDelegate.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-13.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "AppDelegate.h"
#import "CHKeychain.h"
#import "InAppPurchaseManager.h"

@implementation AppDelegate

@synthesize tiku, bFreeVersion;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    //init tiku
//    [NSThread detachNewThreadSelector:@selector(initTiku) toTarget:self withObject:nil];
    [self initTiku];
#ifdef kFreeVersion
    bFreeVersion = YES;
#else
    bFreeVersion = NO;
#endif
    
    NSNumber* n1 = (NSNumber *)[CHKeychain load:KEY_USER_purchased];
    if ([n1 boolValue]) {
        bFreeVersion = NO;
    }
    
    //init iap manager.
    [InAppPurchaseManager initInAppPurchase];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initTiku {
    NSData* d1 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tiku" ofType:@"txt"]];
    NSError* e1;

    NSArray* yuanTiku = [NSJSONSerialization JSONObjectWithData:d1 options:0 error:&e1];
    
    NSMutableArray* a2 = [NSMutableArray array];
    //10以内、20以内、100以内、500以内。
    for (int i=0; i<4; i++) {
        NSMutableArray* a3 = [NSMutableArray array];
        // + - * /
        for (int j=0; j<4; j++) {
            NSMutableArray* a4 = [NSMutableArray array];
            [a3 addObject:a4];
        }
        
        [a2 addObject:a3];
        
    }
    
    for (NSArray* a1 in yuanTiku) {
        NSMutableArray* a5;
        NSMutableArray* a6;
        
        NSNumber* n1 = [a1 objectAtIndex:3];
        switch ([n1 intValue]) {
            case 1: //+
            {
                a5 = [a2 objectAtIndex:0];
            }
                break;
                
            case 2: //-
            {
                a5 = [a2 objectAtIndex:1];
            }
                break;
                
            case 4: //*
            {
                a5 = [a2 objectAtIndex:2];
            }
                break;
                
            case 8: ///
            {
                a5 = [a2 objectAtIndex:3];
            }
                break;
                
            default:
                break;
        }
        
        //10以内、20以内、100以内、500以内。
        NSNumber* n2 = [a1 objectAtIndex:0];
        switch ([n2 intValue]) {
            case 10:
            {
                a6 = [a5 objectAtIndex:0];
            }
                break;
                
            case 20:
            {
                a6 = [a5 objectAtIndex:1];
            }
                break;
                
            case 100:
            {
                a6 = [a5 objectAtIndex:2];
            }
                break;
                
            case 500:
            {
                a6 = [a5 objectAtIndex:3];
            }
                break;
                
            default:
                break;
        }
        
        [a6 addObject:a1];
    }
    
    tiku = a2;
    //10以内没有乘除
}

@end

void TTAlertNoTitle(NSString* message, id delegate) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}

void ssAlertNoTitle(NSString* message, NSString* btnTitle, id delegate) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), btnTitle, nil];
    [alert show];
}
