//
//  ViewController.m
//  WeChat
//
//  Created by birneysky on 16/3/20.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewController.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (strong, nonatomic) IBOutlet ChatTableViewController *chatTVC;

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) LCBottomBarState bottomState;

@end

@implementation ChatViewController

#pragma mark - *** Properties ***
- (void)setBottomState:(LCBottomBarState)bottomState
{
    _bottomState = bottomState;
    [self updateBottomViewState];
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - *** Helper ***
- (void)updateBottomViewState
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:7];
    switch (self.bottomState) {
        case LCBottomBarStateNormal:
            self.bottomViewBottomConstraint.constant = 0 ;
            self.tableViewBottomConstraint.constant = 0;
            break;
        case LCBottomBarStateAudioRecord:
            break;
        case LCBottomBarStateExpressionPanel:
            break;
        case LCBottomBarStateCorePanel:
            break;
        case LCBottomBarStateInputText:
            self.bottomViewBottomConstraint.constant = self.keyboardHeight ;
            self.tableViewBottomConstraint.constant = self.keyboardHeight;
            break;
        default:
            break;
    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
}

#pragma mark - *** Notification Selector ***

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    

    self.keyboardHeight = keyboardRect.size.height;
    self.bottomState = LCBottomBarStateInputText;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
}

@end
