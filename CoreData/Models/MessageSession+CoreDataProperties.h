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
@property (nullable, nonatomic, retain) NSDate *sendTime;
@property (nullable, nonatomic, retain) NSNumber *groupType;
@property (nullable, nonatomic, retain) NSSet<Message *> *messages;

@end

@interface MessageSession (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet<Message *> *)values;
- (void)removeMessages:(NSSet<Message *> *)values;

@end

NS_ASSUME_NONNULL_END
