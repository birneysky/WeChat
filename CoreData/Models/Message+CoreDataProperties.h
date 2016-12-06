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

@property (nullable, nonatomic, retain) NSNumber *fromUserID;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *toUserID;
@property (nullable, nonatomic, strong) NSDate*   sendTime;
@property (nullable, nonatomic, retain) MessageSession *session;

@end

NS_ASSUME_NONNULL_END
