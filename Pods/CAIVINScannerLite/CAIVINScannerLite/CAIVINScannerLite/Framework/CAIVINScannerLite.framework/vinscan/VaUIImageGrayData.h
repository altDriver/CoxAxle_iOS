//
//  VAUIImageGrayData.h
//  VaTouch
//
//  Created by David Rice on 11/12/10.
//  Copyright 2010 vAuto, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

struct VASize {
    NSUInteger width;
    NSUInteger height;
};
typedef struct VASize VASize;

static inline VASize VASizeMake(NSUInteger width, NSUInteger height){
    VASize size; size.width = width; size.height = height; return size;
}


@interface VaUIImageGrayData : NSObject {
    
@private
    UIImage *_image;
    
    NSUInteger _bytesPerRow;
    unsigned char * _grayData;
    
@protected
    VASize _size;
    
}
@property (nonatomic,readonly) VASize size;
@property (nonatomic,readonly) UIImage *image;
@property (nonatomic,readonly) NSUInteger bytesPerRow;
@property (nonatomic,readonly) unsigned char * grayData;

- (void) prepareData;

- (id) initWithUIImage: (UIImage*) image;

- (void) getRow: (NSUInteger) y row: (unsigned char*) row length: (NSUInteger) length;

- (void) getImage: (unsigned char*) image size: (NSUInteger) size;

@end
