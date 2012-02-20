//
//  UserDefault.h
//  QuickDropShot
//
//  Created by 水野 真史 on 12/02/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum QdImageQuality {
    QdImageQualityLow    = 0,
    QdImageQualitySemLow = 1,
    QdImageQualityMiddle = 2,
    QdImageQualityHi     = 3,
    };

enum QdImageSize {
    QdImageSizeFull = 0,
    QdImageSizeQXGA = 1,
    QdImageSizeUXGA = 2,
    QdImageSizeXGA  = 3,
    QdImageSizePAL  = 4,
    QdImageSizeQVGA = 5,
    };


@interface QdUserDefault : NSObject

- (void)setApplicationUserDefault;

@end
