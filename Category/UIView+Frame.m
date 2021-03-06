//
//  UIView+Frame.m
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGPoint) origin {
    return self.frame.origin;
}

- (void) setOrigin:(CGPoint) point {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

- (CGPoint)leftTop
{
    return self.origin;
}

- (CGPoint)rightTop
{
    return CGPointMake(self.x + self.width, self.y);
}

- (CGPoint)leftBottom
{
    return CGPointMake(self.x, self.y + self.height);
}

- (CGPoint)rightBottom
{
    return CGPointMake(self.x + self.width, self.y + self.height);
}


@end
