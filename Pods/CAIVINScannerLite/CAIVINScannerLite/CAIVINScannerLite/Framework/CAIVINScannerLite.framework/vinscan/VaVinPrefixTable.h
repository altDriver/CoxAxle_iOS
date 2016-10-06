//
//  VinPrefixTable.h
//  VaTouch
//
//  Created by David Berry on 13/07/11.
//  Copyright (c) 2013 vAuto LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VaVinPrefixTable : NSObject

@property (nonatomic, strong, readonly) NSString*   eTag;
@property (nonatomic, strong, readonly) NSURL*      localUrl;
@property (nonatomic, strong, readonly) NSURL*      remoteUrl;

+(VaVinPrefixTable*)sharedInstance;

-(void)setBaseUrl:(NSURL*)baseUrl;
-(void)updateCompletion:(void(^)(VaVinPrefixTable* table, NSError* error))completion;

@end
