//
//  NetworkManager.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTTP_REQUEST_TYPE) {
    HTTP_REQUEST_TYPE_GET,
    HTTP_REQUEST_TYPE_POST,
    HTTP_REQUEST_TYPE_DELETE,
    HTTP_REQUEST_TYPE_PUT,
    HTTP_REQUEST_TYPE_PATCH
};

typedef void (^BeforeLoadBlockType)(void);
typedef void (^AfterLoadBlockType)(void);
typedef void (^MTLSuccessBlockType)(NSURLSessionDataTask * _Nonnull task, id _Nullable response);
typedef void (^MTLFailureBlockType)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@class AFHTTPSessionManager;

@interface NetworkManager : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)instance;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

- (void)cancelAllOperations;

- (void)setDefaultRequestSerializerContentType;
- (void)setAuthorizationHeaderFieldsWithUsername:(NSString *)username
                                        password:(NSString *)password;

- (void)requestWithType:(HTTP_REQUEST_TYPE)requestType
                    url:(NSString *)url
             parameters:(NSDictionary * _Nullable)parameters
             beforeLoad:(BeforeLoadBlockType _Nullable)beforeLoad
              afterLoad:(AfterLoadBlockType _Nullable)afterLoad
                success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable response))success
                failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

NS_ASSUME_NONNULL_END

@end
