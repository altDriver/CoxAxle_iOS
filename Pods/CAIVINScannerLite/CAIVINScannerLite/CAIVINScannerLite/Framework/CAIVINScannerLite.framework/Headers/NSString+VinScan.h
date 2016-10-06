//
//  NSString+VinScan.h
//  VinScan
//
//  Created by David Berry on 13/08/27.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    VinPrefixValidityInvalid,
    VinPrefixValidityIncomplete,
    VinPrefixValidityComplete,
} VaVinPrefixValidity;

@interface NSString (VinScan)

-(BOOL)isValidVin;
-(VaVinPrefixValidity)isValidVinPrefix:(NSCharacterSet**)possibleNextChars;

@end
