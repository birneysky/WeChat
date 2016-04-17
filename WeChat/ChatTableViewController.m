//
//  ChatTableViewController.m
//  WeChat
//
//  Created by birneysky on 16/3/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatViewController.h"
#import "CoreDataHelper.h"
#import "Message.h"

@interface ChatTableViewController ()

@property (nonatomic, strong) NSMutableArray* arraySource;

@end

@implementation ChatTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

#pragma mark - *** Properties ***
- (NSMutableArray*)arraySource
{
    if (!_arraySource) {
        _arraySource = [[NSMutableArray alloc] initWithCapacity:100];
        for ( int i = 0; i < 8; i++) {
            [_arraySource addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _arraySource;
}

- (ChatViewController*)chatVC
{
    return (ChatViewController*)self.parentViewController;
}

#pragma mark - *** Init View ***
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureFetch];
//    [self performFetch];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MessageCell"];
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

- (void)configureFetch
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"fromUserID" ascending:YES]];
    NSPredicate* predict = [NSPredicate predicateWithFormat:@"session == %@",self.session];
    [fetchRequest setPredicate:predict];
    [fetchRequest setFetchBatchSize:50];
    CoreDataHelper* helper = [CoreDataHelper defaultHelper];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:helper.defaultContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}

#pragma makr - *** Helper ***
- (void)setSession:(MessageSession *)session
{
    _session = session;
    [self configureFetch];
    [self performFetch];
}

- (void) performFetch
{
    if (self.frc) {
        [self.frc.managedObjectContext performBlock:^{
            NSError* error = nil;
            if (![self.frc performFetch:&error]) {
                DebugLog(@"Failed to perform fetch : %@",error);
            }
            [self.tableView reloadData];
            NSUInteger count =  [[self.frc.sections objectAtIndex:0] numberOfObjects];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message* message = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = message.content;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - *** UIScrollViewDelegate ***
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[self chatVC] setBottomState:LCBottomBarStateNormal];
    [[self chatVC].textView resignFirstResponder];
}

@end
