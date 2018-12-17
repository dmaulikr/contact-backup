//
//  ApiCallManager.m
//
//  Created by Maulik Desai on 20/11/17.
//  Copyright 2017 Desai. All rights reserved.
//

#import "ApiCallManager.h"

@implementation ApiCallManager

ApiCallManager *sharedApiCallManager = nil;

+(ApiCallManager *)sharedApiCallManager
{
	if(sharedApiCallManager == nil)
	{
		sharedApiCallManager = [[ApiCallManager alloc] init];
	}
	return sharedApiCallManager;
}

- (void)callAPIWithDelegate:(id<ApiCallManagerDelegate>)delegate withURL:(NSString *)strURL withData:(NSMutableDictionary *)dict andCallBack:(CallTypeEnum)callBack
{
    _delegate = delegate;
    
    NSString * encodedString = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    
    if (dict != nil) {
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
    }
    
    requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:callBack];

    NSLog(@"this is request:%@",request);
}

#pragma mark -
#pragma mark HTTPRequestHandler Delegates
#pragma mark -

- (void)requestHandler:(HTTPRequestHandler *)requestHandler1 didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:callType];
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
	[_delegate parserDidFailWithError:error andCallType:callType];
}

@end
