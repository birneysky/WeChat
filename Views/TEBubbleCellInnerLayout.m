//
//  TEBubbleCellInnerLayout.m
//  Telescope
//
//  Created by zhangguang on 16/12/9.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCellInnerLayout.h"
#import "TETextLayoutModel.h"
#import "TETextFrameParser.h"
#import "TEChatXMLReader.h"
#import "Message+CoreDataProperties.h"
#import "NSDate+Utils.h"




@interface TEBubbleCellInnerLayout ()

@property (nonatomic,strong) TETextLayoutModel* layoutModel;


@end

@implementation TEBubbleCellInnerLayout


#pragma mark - *** Api ***
- (instancetype)initWithMessage:(Message*)message
{
    if (self = [super init]) {
        NSString* text = message.content;
        TEChatMessage* chatMessage = [TEChatXMLReader messageForXmlString:text error:nil];
        _layoutModel = [TETextFrameParser parseChatMessage:chatMessage];
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        NSString* timeText = [message timeLabelString];
        
        CGSize timeTextSize = [timeText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        
        _timeLabelFrame = CGRectMake((screenW - timeTextSize.width) / 2, Spacing, timeTextSize.width + 15, 20);
       
        CGFloat contentY = CGRectGetMaxY(_timeLabelFrame) + Spacing;
//        CGFloat avatarX = Spacing;
//        if (message.senderIsMe) {
//            avatarX = screenW - Spacing - AvatarWidth;
//        }
        
        //_avatarFrame = CGRectMake(avatarX,avatarY, AvatarWidth, AvatarHeight);
        
        
        CGFloat contextX = 0;
        if (message.senderIsMe) {
            contextX = screenW - _layoutModel.width - Spacing - 11;
            _contentInset = UIEdgeInsetsMake(4, 5, 12, 11);
        }
        else{
            contextX = Spacing;
            //左边距12，顶边距4，右边距6，底边距12
            _contentInset = UIEdgeInsetsMake(4, 12, 12, 4);
        }
        
        _contentFrame = CGRectMake(contextX, contentY, _layoutModel.width + Spacing * 2, _layoutModel.height+ Spacing * 2);

    }
    return self;
}

- (CGFloat)cellHeight
{
    return CGRectGetMaxY(_contentFrame) + Spacing;
}



@end
