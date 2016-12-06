//
//  MessageSession+CoreDataProperties.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MessageSession+CoreDataProperties.h"

@implementation MessageSession (CoreDataProperties)

@dynamic groupID;
@dynamic remoteUserID;
@dynamic sendTimeForLastMessage;
@dynamic groupType;
@dynamic messages;

@end
