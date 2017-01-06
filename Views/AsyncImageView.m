//
//  AsyncImageView.m
//  WeChat
//
//  Created by birneysky on 2017/1/1.
//  Copyright © 2017年 birneysky. All rights reserved.
//

#import "AsyncImageView.h"
#import "YYTextAsyncLayer.h"

@interface AsyncImageView ()<YYTextAsyncLayerDelegate>

@end

@implementation AsyncImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //self.asyncLayer.displaysAsynchronously = YES;
        [self.layer setNeedsDisplay];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)){
        [self.layer setNeedsDisplay];
    }
}

+ (Class)layerClass
{
    return [YYTextAsyncLayer class];
}

- (YYTextAsyncLayer*)asyncLayer
{
    return (YYTextAsyncLayer*)self.layer;
}


#pragma mark - YYTextAsyncLayerDelegate

- (YYTextAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    YYTextAsyncLayerDisplayTask *task = [YYTextAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer){
         //[layer removeAnimationForKey:@"contents"];
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)){
       if(isCancelled()) return;
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        UIImage* image = [UIImage imageNamed:@"coretext-image-1"];
        CGContextDrawImage(context, (CGRect){0,0,size.width,size.height}, image.CGImage);
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished){
        
    };
    
    return task;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
