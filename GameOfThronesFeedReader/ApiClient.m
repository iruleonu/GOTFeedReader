//
//  ApiClient.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "ApiClient.h"
#import <AFNetworking/AFNetworking.h>
#import "FacadeAPI.h"
#import "NetworkManager.h"

@interface ApiClient ()

@property (nonatomic, strong, readwrite, nonnull) NetworkManager *networkManager;

@end

@implementation ApiClient

+ (instancetype)instance {
    return [FacadeAPI sharedInstance].apiClient;
}

- (instancetype)initWithNetworkManager:(NetworkManager *)networkManager {
    if (self = [super init]) {
        self.networkManager = networkManager;
    }
    return self;
}

+ (NSDictionary *)dictionaryForError:(NSError *)error {
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    return [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
}

@end
