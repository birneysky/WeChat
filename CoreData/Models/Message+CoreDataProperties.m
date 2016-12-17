//
//  Message+CoreDataProperties.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

@dynamic mID;
@dynamic senderID;
@dynamic receiverID;
@dynamic content;
@dynamic sendTime;
@dynamic type;
@dynamic recvTime;
@dynamic sessionID;
@dynamic senderIsMe;

@end
