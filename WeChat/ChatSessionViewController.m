//
//  ChatSessionViewController.m
//  WeChat
//
//  Created by birneysky on 16/4/16.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatSessionViewController.h"
#import "MessageSession.h"
#import "ChatViewController.h"

@implementation ChatSessionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:@"SomethingChanged"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

#pragma mark - *** Configure ***
- (void)configureFetch
{
    CoreDataHelper* dataHelper = [CoreDataHelper defaultHelper];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"MessageSession"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:NO]];
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

#pragma mark - *** ***

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatViewController* chatVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"show details"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        MessageSession* session = [self.frc objectAtIndexPath:indexPath];
        //NSOrderedSet* set = session.messages;
        chatVC.session = session;
    }
}

@end
