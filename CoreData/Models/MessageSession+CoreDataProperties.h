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

@property (nullable, nonatomic, retain) NSNumber *groupID;
@property (nullable, nonatomic, retain) NSNumber *remoteUserID;
@property (nullable, nonatomic, retain) NSDate *sendTimeForLastMessage;
@property (nullable, nonatomic, retain) NSNumber *groupType;
@property (nullable, nonatomic, retain) NSOrderedSet<Message *> *messages;

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
