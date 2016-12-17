//
//  MessageSession+CoreDataProperties.h
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MessageSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageSession (CoreDataProperties)

@property (nonatomic) int64_t groupID;
@property (nonatomic) int16_t groupType;
@property (nonatomic) int64_t senderID;
@property (nullable, nonatomic, copy) NSDate *timeToRecvLastMessage;
@property (nullable, nonatomic, copy) NSString *overviewOfLastMessage;
@property (nonatomic) int16_t lastMessageType;
@property (nonatomic, assign) int32_t sID;
@property (nonatomic, assign) int32_t totalNumOfMessage;

@end

@interface MessageSession (CoreDataGeneratedAccessors)

- (void)insertObject:(Message *)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray<Message *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(Message *)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray<Message *> *)values;
- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSOrderedSet<Message *> *)values;
- (void)removeMessages:(NSOrderedSet<Message *> *)values;

@end

NS_ASSUME_NONNULL_END
