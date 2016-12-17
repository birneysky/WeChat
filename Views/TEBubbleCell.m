//
//  TEBubbleCell.m
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCell.h"
#import "TETextLayoutView.h"
#import "Message.h"
#import "Message+CoreDataProperties.h"
#import "TEMessageView.h"
#import "TEBubbleCellInnerLayout.h"

@interface TEBubbleCell ()<TETextLayoutViewDelegate>

@property (nonatomic,strong) UILabel* timeLabel;

@property (nonatomic,strong) TEMessageView* messageView;

@end

@implementation TEBubbleCell

- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}

- (TEMessageView*)messageView
{
    if (!_messageView) {
        _messageView = [[TEMessageView alloc] init];
        _messageView.layoutView.delegate = self;
    }
    return _messageView;
}

#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.messageView];
    [self.contentView addSubview:self.timeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //UIImage* image = [UIImage imageNamed:@"xxx"];
    //image resizableImageWithCapInsets:<#(UIEdgeInsets)#> resizingMode:<#(UIImageResizingMode)#>
}


#pragma mark - *** Api ***

- (void)setMessage:(Message*)message;
{
    self.messageView.contentInset = message.layout.contentInset;
    self.messageView.frame = message.layout.contentFrame;//CGRectMake(self.headImageBtn.rightTop.x, 8, message.layout.contentFrame.size.width, message.layout.cellHeight);
    self.timeLabel.frame = message.layout.timeLabelFrame;
  
    self.timeLabel.text = message.timeLabelString;
    
    if (message.senderIsMe) {
        UIImage* image = [UIImage imageNamed:@"sendto_bubble_bg"];
        self.messageView.image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10) resizingMode:UIImageResizingModeStretch];
    }
    else{
        UIImage* image = [UIImage imageNamed:@"bubble_left"];
        self.messageView.image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 22) resizingMode:UIImageResizingModeStretch];

    }
    
    [self.messageView.layoutView setLayoutModel:message.layout.layoutModel];
}


#pragma mark - *** TETextLayoutViewDelegate ***
- (void)didSelectImageOfRect:(CGRect)rect inView:(UIView *)view
{
    CGRect rectInCell =  [self convertRect:rect fromView:view];
    NSLog(@"🍎🍎🍎🍎🍎 rectInCell = %@",NSStringFromCGRect(rectInCell));
    if ([self.delegate respondsToSelector:@selector(didSelectImageOfRect:inView:)]) {
        [self.delegate didSelectImageOfRect:rect inView:view];
    }
}

- (void)didSelectLinkOfURL:(NSString *)url
{
    NSLog(@"url %@",url);
    if ([self.delegate respondsToSelector:@selector(didSelectLinkOfURL:)]) {
        [self.delegate didSelectLinkOfURL:url];
    }
}
@end
