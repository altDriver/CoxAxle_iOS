//
//  VaVinScanResult.h
//  SimpleVinScanner
//
//  Created by David Rice on 11/12/10.
//  Copyright 2010 vAuto, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VaVinScanResult : NSObject {
    @private
    NSString * _vin;
    BOOL _complete;
    NSString* _message;
    NSArray* _lines;
    NSTimeInterval _timeSpan;
    BOOL isTwoD;
}

@property (nonatomic,copy) NSString *vin;
@property (nonatomic) BOOL complete;
@property (nonatomic,retain) NSArray* lines;
@property (nonatomic) NSTimeInterval timeSpan;
@property (nonatomic,copy) NSString *message;
@property BOOL isTwoD;

+ (id) resultWithVin: (NSString*) vin complete: (BOOL) complete;

+ (id) resultWithMessage: (NSString*) message;

+ (id) resultWithLines: (NSArray*) lines;

- (id) initWithVin: (NSString*) vin complete: (BOOL) complete;

- (id) initWithMessage: (NSString*) message;

- (id) initWithLines: (NSArray*) lines;

@end
