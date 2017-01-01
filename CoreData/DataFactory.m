//
//  DataFactory.m
//  WeChat
//
//  Created by birneysky on 16/4/17.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "DataFactory.h"
#import "CoreDataHelper.h"
#import "Message.h"
#import "MessageSession.h"
#import "TEChatMessage.h"
#import "NSString+UUID.h"
#import "Message+CoreDataProperties.h"

@interface DataFactory ()

@property (nonatomic,strong) dispatch_queue_t workQueue;

@property (nonatomic,assign) BOOL runing;

@property( nonatomic,strong) NSDate* previousdate;

@end

@implementation DataFactory

#pragma mark - *** Properties ***
- (dispatch_queue_t) workQueue
{
    if (!_workQueue) {
        _workQueue  = dispatch_queue_create("com.github.dataFactory", DISPATCH_QUEUE_SERIAL);
    }
    return _workQueue;
}

#pragma makr - *** **** 
- (void)produceMessages:(NSNumber*)userID index:(NSUInteger)index
{
//    __weak CoreDataHelper* helper = [CoreDataHelper defaultHelper];
//    [helper.backgroundContext performBlock:^{
//        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
//        NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUserID == %@",userID];
//        [fetchRequest setPredicate:predicat];
//        NSError* error;
//        NSArray* result = [helper.backgroundContext executeFetchRequest:fetchRequest error:&error];
//
//        Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:helper.backgroundContext];
//        message.fromUserID = userID;
//        message.content = [NSString stringWithFormat:@" %@ ---> 💋💋💋 self are you ok  💋💋💋  %lu",userID,index];
//        message.toUserID = @100;
//        message.sendTime = [NSDate date];
//        MessageSession* session;
//        if (result.count  ==  0) {
//            NSInteger sessionCount = [helper.backgroundContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"MessageSession"] error:nil];
//            session = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSession" inManagedObjectContext:helper.backgroundContext];
//            session.remoteUserID =userID;
//            session.groupID = @0;
//            session.groupType = @0;
//            session.sendTimeForLastMessage = [NSDate date];
//            session.sID = sessionCount + 1;
//        }
//        else if (result.count == 1){
//            session = result.firstObject;
//            session.sendTimeForLastMessage = [NSDate date];
//            //[session addMessagesObject:message];
//           
//        }
//        else{
//            assert(0);
//        }
//        
//         message.sessionID = session.sID;
//        session.totalNumOfMessage += 1;
//        
//        [helper saveBackgroundContext];
//        //[helper.backgroundContext refreshObject:message mergeChanges:NO];
//        //[helper.backgroundContext refreshObject:session mergeChanges:NO];
//        //[helper.backgroundContext refreshAllObjects];
//        NSLog(@"backgroundContext managed object count = %lu",[[helper.backgroundContext registeredObjects] count]);
//        
//        if ([[NSDate date] timeIntervalSinceDate:self.previousDate] > 3) {
//            
//          [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
//            //[helper.backgroundContext refreshAllObjects];
//            self.previousDate = [NSDate date];
//
//        }
//        
//    }];
    NSDate* date = [NSDate date];
    __weak NSManagedObjectContext* weakContext = [CoreDataHelper defaultHelper].backgroundContext;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
    NSPredicate* predicat = [NSPredicate predicateWithFormat:@"senderID == %lld",[userID longLongValue]];
    [fetchRequest setPredicate:predicat];
    NSError* error;
    NSArray* result = [weakContext executeFetchRequest:fetchRequest error:&error];
    [weakContext performBlock:^{
        TEChatMessage* chatMessage = [[TEChatMessage alloc] init];
        chatMessage.isAutoReply = NO;
        chatMessage.messageID = [NSString UUID];
        
        
        BOOL isProduceText = arc4random() % 2 == 0 ? YES : NO;
        if (isProduceText) {
            TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
            textItem.textContent = @"念小编有一个好消息要告诉大家，我们的“老外说”终于要回归了！";
            [chatMessage addItem:textItem];
        }
        
        if (isProduceText) {
            for (int i = 0;  i < arc4random() % 10; i++) {
                TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
                faceItem.imagePosition = CGRectMake(0, 0, 24, 24);
                NSUInteger expressionIndex = arc4random() % 105;
                //NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
                NSString* itemName = [NSString stringWithFormat:@"%ld",expressionIndex];
                //NSString* imageName = [path stringByAppendingPathComponent:itemName];
                faceItem.fileName = itemName;
                [chatMessage addItem:faceItem];
                
                TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
                textItem.textContent = @"把每个角落刻满你我的名字 闪烁着光芒就像宝石那样子 一同经历过磨砺万次 ";
                [chatMessage addItem:textItem];
            }
        }
        
        BOOL isproduceLink = arc4random() % 2 == 0 ? YES : NO;
        if (isproduceLink) {
            TEMsgLinkSubItem* linkItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
            linkItem.url = @"www.baidu.com";
            [chatMessage addItem:linkItem];
        }
        
        if (isproduceLink) {
            TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
            faceItem.imagePosition = CGRectMake(0, 0, 24, 24);
            NSUInteger expressionIndex = arc4random() % 100;
            //NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
            NSString* itemName = [NSString stringWithFormat:@"%ld",expressionIndex];
            faceItem.fileName = itemName;
            [chatMessage addItem:faceItem];
        }
        
        
        
        TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textItem.textContent = [NSString stringWithFormat:@"%@:%lu ---> self are you ok",userID,index];
        [chatMessage addItem:textItem];
        
        
        NSString* content = [chatMessage xmlString];
        Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:weakContext];
        message.mID = chatMessage.messageID;
        message.senderID = [userID longLongValue];
        message.receiverID = 100001;
        message.content = content;
        message.sendTime = date;
        message.type = 0;
        message.recvTime = [NSDate date];
        
        //NSLog(@"context Xml %@",content);
        
        MessageSession* session = nil;
        
        if (result.count == 0) {
//            NSInteger sessionCount = [weakContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"MessageSession"] error:nil];
            session  = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSession" inManagedObjectContext:weakContext];
            session.groupID = 0;
            session.groupType = 0;
            session.senderID = [userID longLongValue];
            session.timeToRecvLastMessage = [NSDate date];
            session.overviewOfLastMessage = [NSString stringWithFormat:@"%@:%lu ---> self are you ok",userID,index];
            session.lastMessageType = message.type;
            session.sID = (int32_t)[userID longLongValue];
        }
        else if (1 == result.count){
            session = result.firstObject;
            session.timeToRecvLastMessage = [NSDate date];
            session.lastMessageType = message.type;
            //[session addMessagesObject:message];
        }
        else{
            assert(0);
        }
        
        message.sessionID = session.sID;
        session.totalNumOfMessage += 1;
        
        [message layout];
        
        [[CoreDataHelper defaultHelper] saveBackgroundContext];
        NSDate* ttDate = [NSDate date];
        if( [ttDate timeIntervalSinceDate:self.previousdate] > 3){
            self.previousdate = ttDate;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
        }
        
    }];
    
}

#pragma mark - *** api ***
- (void)start
{
    //sleep(20);
    NSArray* usrIDs = @[@100001,@100002,@100003,@100004,@100005/*,@100006,@100007,@100008,@100009,@100010,@100011,@100012,@100013,@100014,@100015,@100016,@100017,@100018,@100019,@100020,@100021,@100022,@100023,@100024,@100025,@100026,@100027,@100028*/];
    self.runing = YES;
    
    self.previousdate = [NSDate date];
    __weak DataFactory* weakSelf = self;
    dispatch_async(self.workQueue, ^{
        NSUInteger count = 0;
        NSPort* dummyPort = [NSMachPort port];
        [[NSRunLoop currentRunLoop] addPort:dummyPort forMode:NSDefaultRunLoopMode];
        while (weakSelf.runing) {
            @autoreleasepool {
                NSInteger index = arc4random() % [usrIDs count];
                
                [weakSelf produceMessages:usrIDs[index] index:count++];
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:3]];
            }

        }
    });

}

- (void)stop
{
    __weak DataFactory* weakSelf = self;
    dispatch_async(self.workQueue, ^{
        weakSelf.runing = NO;
    });
}

- (void)dealloc
{
    //dispatch_release(self.workQueue);
}

@end
