//
//  TEBubbleCellInnerLayout.h
//  Telescope
//
//  Created by zhangguang on 16/12/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>


#define AvatarWidth 44
#define AvatarHeight 44

#define Spacing 8


@class Message;
@class TETextLayoutModel;



@interface TEBubbleCellInnerLayout : NSObject


/**
 时间标签位置
 */
@property (nonatomic, assign, readonly) CGRect timeLabelFrame;

/**
 消息内容位置
 */
@property (nonatomic, assign, readonly) CGRect contentFrame;

/**
 cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;


/**
 排版模型
 */
@property (nonatomic, strong, readonly)TETextLayoutModel* layoutModel;


/**
 内容显示的边距
 */
@property (nonatomic,assign) UIEdgeInsets contentInset;


- (instancetype)initWithMessage:(Message*)message;



@end
