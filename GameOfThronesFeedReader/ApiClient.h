//
//  ApiClient.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

typedef void (^ _Nullable SuccessBlockType)(void);
typedef void (^ _Nullable FetchElementsSuccessBlockType)(NSArray * _Nullable elements);
typedef void (^ _Nullable FetchElementsPaginatedSuccessBlockType)(NSArray * _Nullable elements, BOOL isLast);
typedef void (^ _Nullable FetchElementSuccessBlockType)(id _Nullable element);
typedef void (^ _Nullable ErrorBlockType)(NSError * _Nonnull error);

@interface ApiClient : NSObject

+ (NetworkManager * _Nonnull)networkManager;

@end
