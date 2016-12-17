//
//  TETextAttibuteConfig.m
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TETextAttibuteConfig.h"

@implementation TETextAttibuteConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 260.0f;
        _fontSize = 17.0f;
        _lineSpace = 4.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
