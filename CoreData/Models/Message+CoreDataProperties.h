//
//  Message+CoreDataProperties.h
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

@property (nullable, nonatomic, copy) NSString* mID;
@property (nonatomic) int64_t senderID;
@property (nonatomic) int64_t receiverID;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *sendTime;
@property (nonatomic, assign) int16_t type;
@property (nullable, nonatomic, copy) NSDate *recvTime;
@property (nonatomic, assign) int32_t sessionID;
@property (nonatomic,assign) BOOL senderIsMe;

@end

NS_ASSUME_NONNULL_END
