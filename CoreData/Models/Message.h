//
//  Message.h
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MessageSession;
@class TEBubbleCellInnerLayout;

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic,readonly) TEBubbleCellInnerLayout* layout;

@property (nonatomic,readonly,copy) NSString* timeLabelString;

@end

NS_ASSUME_NONNULL_END

#import "Message+CoreDataProperties.h"
