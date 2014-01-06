//
//  Created by Matt Greenfield on 24/05/12
//  Copyright (c) 2012 Big Paua. All rights reserved
//  http://bigpaua.com/
//

#import "ThoughtViewViewController.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "OperationsWithDB.h"
#import "TimeConverting.h"
#import "SVProgressHUD.h"
#import "CP04ViewController.h"
//alertview
#import "UIAlertView+Blocks.h"
#define ANIM_SPEED 0.6

@implementation ThoughtViewViewController {
    MGScrollView *scroller;
    NSInteger counterForBoxes;
    NSMutableArray *content;
    NSInteger counterForModifing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Preparations];

    self.displayView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    
    //self.displayView.backgroundColor = [UIColor colorWithRed:(37.0f/255.0f) green:(37.0f/255.0f) blue:(37.0f/255.0f) alpha:1.0f];

    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];

    // make an MGScrollView for holding boxes
    
    CGRect frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-44);
    scroller = [[MGScrollView alloc] initWithFrame:frame];
    scroller.alwaysBounceVertical = YES;
    scroller.delegate = self;
    [self.displayView addSubview:scroller];
 



    content = [OperationsWithDB fetchAllTheThoughts];
    counterForBoxes = [content count];

    if(counterForBoxes==0)
    {
        [self emptyThought];
    }
    else
    {
      for(Thoughts *tmpT in content)
      {
        
        MGStyledBox *box3 = [MGStyledBox box];
        [scroller.boxes addObject:box3];
        NSString *dateS = [TimeConverting TimeDateINTToString2:tmpT.CreateDate];
        MGBoxLine *head3 = [MGBoxLine lineWithLeft:tmpT.Title right:dateS];
        head3.font = headerFont;
        [box3.topLines addObject:head3];

        NSString *lineContentWords = tmpT.Content;
        MGBoxLine *wordsLine = [MGBoxLine multilineWithText:lineContentWords font:nil padding:24];
        [box3.topLines addObject:wordsLine];
          
        //delete btn
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30,30)];
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(ClickDelete:) forControlEvents:UIControlEventTouchDown];
        [deleteBtn setImage:[UIImage imageNamed:@"deleteICON.png"] forState:UIControlStateNormal];
        //set tag in order to get Tid to delete
          deleteBtn.tag = tmpT.Pid;
          
        //edit btn
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30,30)];
        [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(ClickEdit:) forControlEvents:UIControlEventTouchDown];
        [editBtn setImage:[UIImage imageNamed:@"editICON.png"] forState:UIControlStateNormal];
          //set tag in order to get Tid to edit
          editBtn.tag = tmpT.Pid;

        MGBoxLine *imgLine = [MGBoxLine lineWithLeft:editBtn right:deleteBtn];
        [box3.topLines addObject:imgLine];
      }
    }
    // draw all the boxes and animate as appropriate
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
    [scroller flashScrollIndicators];
}


-(void) ClickDelete:(id)sender
{
    UIButton *tmp = sender;
    MGBox *parentBox = [self parentBoxOf:sender];
    [UIAlertView showConfirmationDialogWithTitle:@"Confirmation"
                                         message:@"Are you sure to delete this thought?"
                                         handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                             
                                             if (buttonIndex == [alertView cancelButtonIndex]) {
                                                 //click cancel
                                                 
                                             } else {
                                                 //click delete
                                                 //delete in db
                                                 [OperationsWithDB deleteAThought:tmp.tag];
                                                 //reload table in view
                                                 [scroller.boxes removeObject:parentBox];
                                                 [scroller drawBoxesWithSpeed:ANIM_SPEED];
                                                 //show return msg
                                                 [SVProgressHUD showSuccessWithStatus:@"Thought Deleted!"];
                                                 //decrement counterForBoxes
                                                 
                                                 counterForBoxes--;
                                                NSLog(@"counterForBoxes is %i",counterForBoxes);
                                                 if(counterForBoxes==0)
                                                 {
                                                     [self emptyThought];
                                                     // draw all the boxes and animate as appropriate
                                                     [scroller drawBoxesWithSpeed:ANIM_SPEED];
                                                     [scroller flashScrollIndicators];
                                                 }
                                             }
                                         }];
}

-(void) ClickEdit:(id)sender
{
    NSLog(@"edit clicked");
    UIButton *tmp = sender;
    int index = tmp.tag;
    Thoughts *toCP04 = [[Thoughts alloc]init];
    for(Thoughts *obj in content)
    {
        NSLog(@"```counterForModifing %i",counterForModifing);
        counterForModifing++;
        NSLog(@"```counterForModifing %i",counterForModifing);
        if(obj.Pid == index)
        {
            toCP04 = obj;
            break;
        }
    }
    CP04ViewController *tv = [self.storyboard instantiateViewControllerWithIdentifier:@"CP04"];
    tv.CP04Thought = toCP04;
    tv.delegate = self;
    [self presentViewController:tv animated:YES completion:nil];
}
#pragma mark - UIScrollViewDelegate (for snapping boxes to edges)

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [(MGScrollView *)scrollView snapToNearestBox];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [(MGScrollView *)scrollView snapToNearestBox];
    }
}


-(void) Preparations
{
    //shadow stuff
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 2.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}
- (IBAction)LeftToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)RightToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}
- (MGBox *)parentBoxOf:(UIView *)view {
    while (![view.superview isKindOfClass:[MGBox class]]) {
        if (!view.superview) {
            return nil;
        }
        view = view.superview;
    }
    return (MGBox *)view.superview;
}

-(void)emptyThought 
{
    MGStyledBox *onlyBox = [MGStyledBox box];
    [scroller.boxes addObject:onlyBox];
    
    MGBoxLine *head  = [MGBoxLine lineWithLeft:@"Dear planner" right:nil];
    head.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [onlyBox.topLines addObject:head];
    
    NSString *lineContentWords = @"You haven't written any thought.\n\n";
    MGBoxLine *wordsLine = [MGBoxLine multilineWithText:lineContentWords font:nil padding:24];
    [onlyBox.topLines addObject:wordsLine];
}

-(void)passInfoback:(CP04ViewController *)controller withThoughts:(Thoughts *)thought
{
    [OperationsWithDB UpdateThoughtTable:thought andPid:thought.Pid];
    NSLog(@"counterForModifing %i",counterForModifing);
    MGStyledBox *old = [scroller.boxes objectAtIndex:counterForModifing-1];
    
    NSLog(@"counterForModifing %i",counterForModifing);
    NSString *dateS = [TimeConverting TimeDateINTToString:thought.CreateDate];
    
    MGBoxLine *new = [MGBoxLine lineWithLeft:thought.Title right:dateS];
    new.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [old.topLines replaceObjectAtIndex:0 withObject:new];
    
    NSString *lineContentWords = thought.Content;
    MGBoxLine *wordsLine = [MGBoxLine multilineWithText:lineContentWords font:nil padding:24];
    [old.topLines replaceObjectAtIndex:1 withObject:wordsLine];

    [scroller drawBoxesWithSpeed:0];
    [scroller flashScrollIndicators];
    
    [content replaceObjectAtIndex:counterForModifing-1 withObject:thought];
    
    counterForModifing=0;
 
}

@end
