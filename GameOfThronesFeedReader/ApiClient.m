//
//  ApiClient.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "ApiClient.h"
#import <AFNetworking/AFNetworking.h>
#import "NetworkManager.h"

@implementation ApiClient

+ (NetworkManager *)networkManager {
    return [NetworkManager sharedInstance];
}

+ (NSDictionary *)dictionaryForError:(NSError *)error {
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    return [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
}

@end
