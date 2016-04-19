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

@interface DataFactory ()

@property (nonatomic,strong) dispatch_queue_t workQueue;

@property (nonatomic,assign) BOOL runing;

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
    __weak CoreDataHelper* helper = [CoreDataHelper defaultHelper];
    [helper.backgroundContext performBlock:^{
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
        NSPredicate* predicat = [NSPredicate predicateWithFormat:@"remoteUserID == %@",userID];
        [fetchRequest setPredicate:predicat];
        NSError* error;
        NSArray* result = [helper.backgroundContext executeFetchRequest:fetchRequest error:&error];

        Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:helper.backgroundContext];
        message.fromUserID = userID;
        message.content = [NSString stringWithFormat:@" %@ ---> self are you ok %lu",userID,index];
        message.toUserID = @100;
        MessageSession* session;
        if (result.count  ==  0) {
            session = [NSEntityDescription insertNewObjectForEntityForName:@"MessageSession" inManagedObjectContext:helper.backgroundContext];
            session.remoteUserID =userID;
            session.groupID = @0;
            session.groupType = @0;
            session.sendTime = [NSDate date];
        }
        else if (result.count == 1){
            session = result.firstObject;
            session.sendTime = [NSDate date];
            message.session = result.firstObject;
        }
        else{
            assert(0);
        }
        
        [helper saveBackgroundContext];
        
        [helper.backgroundContext refreshObject:session mergeChanges:NO];
        [helper.backgroundContext refreshObject:message mergeChanges:NO];
        NSLog(@"backgroundContext managed object count = %lu",[[helper.backgroundContext registeredObjects] count]);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
        
    }];
}

#pragma mark - *** api ***
- (void)start
{
    NSArray* usrIDs = @[@100001,@100002,@100003,@100004,@100005,@100006,@100007,@100008,@100009,@100010,@100011,@100012,@100013,@100014,@100015,@100016,@100017,@100018,@100019,@100020,@100021,@100022,@100023,@100024,@100025,@100026,@100027,@100028];
    self.runing = YES;
    
    __weak DataFactory* weakSelf = self;
    dispatch_async(self.workQueue, ^{
        NSUInteger count = 0;
        NSPort* dummyPort = [NSMachPort port];
        [[NSRunLoop currentRunLoop] addPort:dummyPort forMode:NSDefaultRunLoopMode];
        while (weakSelf.runing) {
            @autoreleasepool {
                NSInteger index = arc4random() % [usrIDs count];
                
                [weakSelf produceMessages:usrIDs[index] index:count++];
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
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
