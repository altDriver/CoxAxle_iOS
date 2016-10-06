//
//  VaSimpleVinReader.h
//  VaTouch
//
//  Created by David Rice on 11/12/10.
//  Copyright 2010 vAuto, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VaVinScanResult;
@class VaUIImageGrayData;

@interface VaSimpleVinReader : NSObject

@property (nonatomic, copy) NSString      *highDefMode;

- (VaVinScanResult*) decode: (VaUIImageGrayData*) grayData;

@end

@interface VaSimpleVinReader1d : VaSimpleVinReader
{
    unsigned int * _rowCheckList;
    NSUInteger _height;
}

@property (nonatomic, assign) BOOL      allowCode128;

@end

@interface VaSimpleVinReader2d : VaSimpleVinReader

@end
