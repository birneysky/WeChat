//
//  ViewController.h
//  WeChat
//
//  Created by birneysky on 16/3/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LCBottomBarState){
    LCBottomBarStateNormal          = 0,
    LCBottomBarStateAudioRecord     = 1 << 0,
    LCBottomBarStateExpressionPanel = 1 << 1,
    LCBottomBarStateCorePanel       = 1 << 2,
    LCBottomBarStateInputText       = 1 << 3
};

@interface ChatViewController : UIViewController


@end

