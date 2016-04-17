//
//  ChatTableViewController.h
//  WeChat
//
//  Created by birneysky on 16/3/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//


#import "CoreDataTableViewController.h"

@class MessageSession;

@interface ChatTableViewController : CoreDataTableViewController

@property (nonatomic,weak) MessageSession* session;

@end
