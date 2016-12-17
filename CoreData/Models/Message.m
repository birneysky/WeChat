//
//  Message.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "Message.h"
#import "MessageSession.h"
#import "TEBubbleCellInnerLayout.h"
#import "NSDate+Utils.h"

@implementation Message

@synthesize layout = _layout;
@synthesize timeLabelString = _timeLabelString;

- (TEBubbleCellInnerLayout*)layout
{
    if (!_layout) {
        _layout = [[TEBubbleCellInnerLayout alloc] initWithMessage:self];
    }
    return _layout;
}

- (NSString*)timeLabelString
{
    if (!_timeLabelString) {
        NSString *dateStr;  //年月日
        NSString *period;   //时间段
        NSString *hour;     //时
        if ([self.sendTime year]==[[NSDate date] year]) {
            
            NSInteger days = [NSDate daysOffsetBetweenStartDate:self.sendTime endDate:[NSDate date]];
            if (days <= 2) {
                dateStr = [self.sendTime stringYearMonthDayCompareToday];
            }else{
                dateStr = [self.sendTime stringMonthDay];
            }
        }else{
            dateStr = [self.sendTime stringYearMonthDay];
        }
        
        
        if ([self.sendTime hour]>=5 && [self.sendTime hour]<12) {
            period = @"AM";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]];
        }else if ([self.sendTime hour]>=12 && [self.sendTime hour]<=18){
            period = @"PM";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]-12];
        }else if ([self.sendTime hour]>18 && [self.sendTime hour]<=23){
            period = @"Night";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]-12];
        }else{
            period = @"Dawn";
            hour = [NSString stringWithFormat:@"%02d",(int)[self.sendTime hour]];
        }
        _timeLabelString = [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[self.sendTime minute]];;
    }
    return _timeLabelString;
}

// Insert code here to add functionality to your managed object subclass
- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ Message dealloc");
}

@end
