//
//  ChatSessionViewController.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatSessionViewController.h"
#import "MessageSession.h"

@implementation ChatSessionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
}


#pragma mark - *** Configure ***
- (void)configureFetch
{
    CoreDataHelper* dataHelper = [CoreDataHelper defaultHelper];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    [request setFetchBatchSize:50];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataHelper.defaultContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}


#pragma mark - *** Table View ***
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Session Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageSession* session = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",session.remoteUserID];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",session.sendTime];
}

@end
