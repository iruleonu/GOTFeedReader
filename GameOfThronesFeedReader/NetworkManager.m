//
//  NetworkManager.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "Networking.h"

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation NetworkManager

+ (instancetype)sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [self setDefaultRequestSerializerContentType];
    }
    
    return self;
}

- (void)cancelAllOperations {
    [self.sessionManager.operationQueue cancelAllOperations];
}

#pragma mark - Networking

- (void)requestWithType:(HTTP_REQUEST_TYPE)requestType
                    url:(NSString *)url
             parameters:(NSDictionary *)parameters
             beforeLoad:(BeforeLoadBlockType _Nullable)beforeLoad
              afterLoad:(AfterLoadBlockType _Nullable)afterLoad
                success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    if (beforeLoad) beforeLoad();
    
    success = ^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        if (afterLoad)
            afterLoad();
        
        if (success)
            success(task, response);
    };
    
    failure = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (afterLoad)
            afterLoad();
        
        if (failure)
            failure(task, error);
    };
    
    switch (requestType) {
        case HTTP_REQUEST_TYPE_GET:
            [self.sessionManager GET:url parameters:parameters progress:nil success:success failure:failure];
            break;
            
        case HTTP_REQUEST_TYPE_POST:
            [self.sessionManager POST:url parameters:parameters progress:nil success:success failure:failure];
            break;
            
        case HTTP_REQUEST_TYPE_DELETE:
            [self.sessionManager DELETE:url parameters:parameters success:success failure:failure];
            break;
            
        case HTTP_REQUEST_TYPE_PUT:
            [self.sessionManager PUT:url parameters:parameters success:success failure:failure];
            break;
            
        case HTTP_REQUEST_TYPE_PATCH:
            [self.sessionManager PATCH:url parameters:parameters success:success failure:failure];
            break;
            
        default:
            break;
    }
}

#pragma mark - Custom

- (void)setAuthorizationHeaderFieldsWithUsername:(NSString *)username password:(NSString *)password {
    [self setDefaultRequestSerializerContentType];
    AFHTTPRequestSerializer *requestSerializer = self.sessionManager.requestSerializer;
    [requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    self.sessionManager.requestSerializer = requestSerializer;
}

- (void)setDefaultRequestSerializerContentType {
    AFJSONRequestSerializer *requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    self.sessionManager.requestSerializer = requestSerializer;
}

@end
