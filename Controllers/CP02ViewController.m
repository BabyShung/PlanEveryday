//
//  CP02ViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/9/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//
#import "AudioToolbox/AudioToolbox.h"
#import "TimeConverting.h"
#import "CP02ViewController.h"
#import "CP03ViewController.h"
#import "CP04ViewController.h"
#import "ActionSheetDatePicker.h"
//time
#import "NSDate+TCUtils.h"

#import "MCSwipeTableViewCell.h"
#import "OperationsWithDB.h"
#import "Event.h"

#import "TDBadgedCell.h"
//return msg
#import "SVProgressHUD.h"
//alertview
#import "UIAlertView+Blocks.h"

#import "LocalNotification.h"
@interface CP02ViewController () <MCSwipeTableViewCellDelegate>

@property(nonatomic, assign) NSUInteger nbItems;
@property(nonatomic, assign) BOOL CantPickToday;
@end

@implementation CP02ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //set delegate
    
    self.selectedDate = [NSDate date];  //dont know why cant be consistent when converting
    [self.DateSelectBtn setTitle:[TimeConverting transfromNSDATEtoNSString:self.selectedDate] forState:UIControlStateNormal];
 
//******************************************************important
    
    if(![self.chosePlan isEqualToString:@"A New Plan"]) //use old plan pattern
    {
        // not equal to 'A New Plan'
        NSLog(@"go here? self.choseDate： %i",self.choseDate);
        [self fetchUsedPlan:self.choseDate];
        
    }
    else    //select a new plan  1.you might have already defined one; 2.create a new one
    {
        //check if there is already a plan today
        NSDate *today = [NSDate date];
        
        if([OperationsWithDB CheckAPlanIsThere:today])
        {
            [self popAlertView:today];
        }
        else//no plan, so create a new plan,then event should be 0
        {
            [self newPlanPreparation];
        }
        
    }
    self.SwipeEventView.delegate=self;
    self.SwipeEventView.dataSource=self;

}

 
#pragma mark - IBActions
 
- (IBAction)SelectADate:(id)sender {
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Tomorrow" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:+1]];
    
    self.actionSheetPicker.hideCancel = YES;
    
    [self.actionSheetPicker showActionSheetPicker];
}


#pragma mark - Implementation

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
         
    int todayInt = [TimeConverting transfromNSDATEtoInt:[NSDate date]];
    int selecteddayInt = [TimeConverting transfromNSDATEtoInt:selectedDate];

    if(todayInt<selecteddayInt)
    {
        //today smaller,means user picked a larger day
        self.selectedDate = selectedDate;
        [self.DateSelectBtn setTitle:[TimeConverting transfromNSDATEtoNSString:self.selectedDate] forState:UIControlStateNormal];
    }
    else if(todayInt==selecteddayInt)
    {
        if(self.CantPickToday == YES)
        {
            [UIAlertView showWarningWithMessage:@"Can't pick today, Plan today exists."
                                        handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                            NSLog(@"Warning dismissed");
                                        }];
        }
        else
        {
            self.selectedDate = selectedDate;
            [self.DateSelectBtn setTitle:[TimeConverting transfromNSDATEtoNSString:self.selectedDate] forState:UIControlStateNormal];
        }
    }
    else
    {
        [UIAlertView showWarningWithMessage:@"Can't pick passed days."
                                    handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        NSLog(@"Warning dismissed");
                                    }];
    }
    
    

}

- (IBAction)BackBtn:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Events"; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(self.nbItems==0&&self.DeleteRowFlag==NO)
    {
        return 1;
    }
    else if(self.nbItems==0&&self.DeleteRowFlag==YES)
    {
        return 0;
    }
    else
    {
        return self.nbItems;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    
    [cell setFirstStateIconName:@"cross.png"
                     firstColor:[UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0]
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0]
                 fourthIconName:@"cross.png"
                    fourthColor:[UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0]];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    //selected
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    //only delete cell
    if(self.nbItems==0)
    {
        [cell.textLabel setText:@"Add an event?"];
    }
    else    //there are >0 Events
    {
        //get the obj
        Event *tmp = [contents objectAtIndex:indexPath.row];
        
        //convert time from int to string
        NSString *hourLeft = [TimeConverting LEFTHOURSIntValueTOString:tmp.StartTime];
        NSString *finalTimeString = [TimeConverting TimeIntToString:tmp.StartTime];
        NSString *result = [NSString stringWithFormat:@"%@   %@",finalTimeString,hourLeft];
        [cell.textLabel setText:tmp.Ename];
        [cell.detailTextLabel setText:result];
        [cell setMode:MCSwipeTableViewCellModeExit];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    return 60.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.nbItems!=0)
    {
        Event *evt=[contents objectAtIndex:indexPath.row];
        if (evt.Eid==0)
        {
            //meaning we pick a row just added (not in the DB)
            evt.didSelectAVirtualCell = YES;
        }
        evt.IndexInSwipeTable = indexPath.row;
        evt.IndexInDBCategory = [OperationsWithDB FetchACategoryForItsCidMinusOne:evt.Category];
        self.ToCP03Event=evt;
 

        [self performSegueWithIdentifier:@"CP02DidSelect" sender:self];

    }
  
    //deselect the lines background
    [self.SwipeEventView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
    
    if (mode == MCSwipeTableViewCellModeExit) {
        
        int index = [self.SwipeEventView indexPathForCell:cell].row;
        
        Event *tmp =[contents objectAtIndex:index];
   
        //if the current cell Eid exists in the db,delete that row in the DB
        if([OperationsWithDB CheckAnEventIsThere:tmp])
        {
            [OperationsWithDB deleteAnEvent:tmp];
        }

        //also,contents array will remove an event object
        [contents removeObjectAtIndex:index];
        
        //row decrement
        if(self.nbItems==1) //in order to solve the inconsistency
        {
            self.DeleteRowFlag=YES;
        }
        
        self.nbItems--;
        
        [self.SwipeEventView deleteRowsAtIndexPaths:@[[self.SwipeEventView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//coming back from CP04
-(void) passInfoback:(CP04ViewController *)controller withThoughts:(Thoughts *)thought
{
    NSLog(@"come back from cp04");
    
    self.ToCP04Thought.Title=thought.Title;
    NSLog(@"------!!!!cp04------%@",self.ToCP04Thought.Title);
    NSLog(@"------!!!!cp04---------%@",self.ToCP04Thought.Content);
    
    if([thought.Content isEqualToString:@"How are you?"])
    {
        self.ToCP04Thought.Content = nil;
    }
    else
    {
        self.ToCP04Thought.Content=thought.Content;
    }
}

//coming back from CP03
-(void) passInfoback:(CP03ViewController *)controller withEvent:(Event *)event
{
    NSLog(@"come back from cp03");
    
    
    if(event.StartTime>2400)
    {
        event.StartTime %= 2400;
        
        //..........
        //set a flag,if an event is for tomorrow,the notification should be changed accordingly
        //.....
    }
    
    

    if(self.isLoadingAExistingTodayPlan == YES)
    {
        
        if(event.Eid!=0)    //existent event will be updated,clicked did select
        {
            event.ShouldBeUpdatedInDB = YES;
            [contents removeObjectAtIndex:event.IndexInSwipeTable];
            [contents insertObject:event atIndex:event.IndexInSwipeTable];
        }
        else if(event.didSelectAVirtualCell== YES)   //this event will be added in db,clicked did select but it's a virtual cell
        {
            event.ShouldBeUpdatedInDB = NO;
            [contents removeObjectAtIndex:event.IndexInSwipeTable];
            [contents insertObject:event atIndex:event.IndexInSwipeTable];
        }
        else    //this event will be added in db
        {
            event.ShouldBeUpdatedInDB = NO;  //not update means insert;

            //add an event object into contents array
            [contents addObject:event];
            //increment events
            self.nbItems++;
        }
    }
    else    //if create this plan, will insert all of them
    {
        if(event.didSelectAVirtualCell == YES)   //a modified cell,no need to increment nbitems
        {
            [contents removeObjectAtIndex:event.IndexInSwipeTable];
            [contents insertObject:event atIndex:event.IndexInSwipeTable];
        }
        else
        {
            [contents addObject:event];
            //increment events
            self.nbItems++;
        }
    }
    

    for(Event *tmpE in contents)
    {
        NSLog(@"Eid:%i",tmpE.Eid);
        NSLog(@"Pid:%i",tmpE.Pid);
        NSLog(@"Ename:%@",tmpE.Ename);
        NSLog(@"StartTime:%i",tmpE.StartTime);
        NSLog(@"EndTime:%i",tmpE.EndTime);
        NSLog(@"Priority:%i",tmpE.Priority);
        NSLog(@"Category:%@",tmpE.Category);
        NSLog(@"isFinished:%d",tmpE.isFinished);
        NSLog(@"notificationID:%d",tmpE.notificationID);
    }

    [self.SwipeEventView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"CP02toCP04"])
    {
        CP04ViewController *cp04 = [segue destinationViewController];
        cp04.delegate=self;
        
        //CP04 textview bug,have to do this
        if([self.ToCP04Thought.Content isEqualToString:@"(null)"])
        {
            self.ToCP04Thought.Content=nil;
        }
        cp04.CP04Thought = self.ToCP04Thought;
    }
    else if ([segue.identifier isEqualToString:@"CP02toCP03"])  //clicking add an new event
    {
        CP03ViewController *cp03 = [segue destinationViewController];
        cp03.delegate=self;

    }
    else if([segue.identifier isEqualToString:@"CP02DidSelect"])
    {
        CP03ViewController *cp03=[segue destinationViewController];
        cp03.CP03Event = self.ToCP03Event;
        cp03.delegate=self;
        //has to disable category for this case,meaning that cant modify the names
        cp03.shouldCategoryToolBeDisabled = YES;
    }
}


- (IBAction)CreateModifyBTNAction:(id)sender {
    
    if(self.isLoadingAExistingTodayPlan == YES) //modifying a plan
    {
        [OperationsWithDB ModifyAPlan:contents andThoughts:self.ToCP04Thought andEffectedDate:self.selectedDate];
        //return msg
        [SVProgressHUD showSuccessWithStatus:@"Plan modified!"];
        NSLog(@"Plan modified!");
        
        
        //some events should be added in notification, some should be just updated
        //......
        
        
        
        for(Event *event in contents)
        {
            NSDate *destinationDate = [TimeConverting getNotLocalTime:self.selectedDate andhourMinute:event.StartTime];
            
            //if set day is larger,then set up notification
            if([TimeConverting setDateLargerThenRightNow:destinationDate]==YES)
            {
                if(event.ShouldBeUpdatedInDB)
                {
                    [LocalNotification CancelExistingNotification:event.notificationID];
                }

                
                [LocalNotification scheduleLocalNotificationWithDate:destinationDate atIndex:event.notificationID andAlertBody:event.Ename andAlertAction:@"Go to App"];

            }
        }
        
        
    }
    else        //create a new plan
    {
        [OperationsWithDB CreateAPlan:contents andThoughts:self.ToCP04Thought andEffectedDate:self.selectedDate];
        //return msg
        [SVProgressHUD showSuccessWithStatus:@"Plan created!"];
        NSLog(@"Plan created!");
        
        NSLog(@"!!!selected date: %@",self.selectedDate);
        
        
        
        for(Event *event in contents)   //all the events will have notification added
        {
            NSDate *destinationDate = [TimeConverting getNotLocalTime:self.selectedDate andhourMinute:event.StartTime];
            NSLog(@"destin date!!!!!!!!!: %@",destinationDate);
            NSLog(@"selec date no good: %@",self.selectedDate);
            NSLog(@"StartTime: %i",event.StartTime);
            
            //if set day is larger,then set up notification
            if([TimeConverting setDateLargerThenRightNow:destinationDate]==YES)
            {
                NSLog(@"should set");
                [LocalNotification scheduleLocalNotificationWithDate:destinationDate atIndex:event.notificationID andAlertBody:event.Ename andAlertAction:@"Go to App"];
            }   
        }
    }
    
    
    

  
    //refresh table and reset the topview
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MainNC" object:nil];
    //dismiss multiple views
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CP01NC" object:nil];
    //dismiss the current presenting view
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

-(void)popAlertView:(NSDate *)today
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dear planner"
                                                    message:@"You've created a plan for today.\nDo you want to modify or create a new future plan?"
                                                   delegate:nil
                                          cancelButtonTitle:@"Go back"
                                          otherButtonTitles:@"Modify", @"Create", nil];
    
    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
            //delay code
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }
        else if(buttonIndex==1) //click modify
        {
            //show loading dialog
            [SVProgressHUD showWithStatus:@"Loading data"];
            
            //load stuff from db
            [self fetchTodaysPlan:today];
            
            [self.SwipeEventView reloadData];
            NSLog(@"You clicked the button at index %i", buttonIndex);
            
            
            //delay code
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                [SVProgressHUD dismiss];
            });
     
        }
        else    //click create
        {
            [self newPlanPreparation];
            //one thing to note is we shouldnt pick today (or before) for a plan since it exists.
            self.CantPickToday = YES;
            
            self.selectedDate = [[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:+1];
            [self.DateSelectBtn setTitle:[TimeConverting transfromNSDATEtoNSString:self.selectedDate] forState:UIControlStateNormal];
        }
    }];
    
}

-(void)fetchTodaysPlan:(NSDate *)today
{
    contents = [OperationsWithDB fetchEvents:today];
    
    self.ToCP04Thought = [OperationsWithDB fetchThought:today];
    
    self.CreateModifyBTN.title=@"Modify";
    
    self.nbItems=[contents count];
    
    self.isLoadingAExistingTodayPlan = YES;

    //since it's modifying today's plan, we can't let user change date
    self.DateSelectBtn.enabled = NO;
}

-(void)fetchUsedPlan:(NSInteger) date
{
    contents = [OperationsWithDB fetchEventsByInt:date];
    
    self.ToCP04Thought = [OperationsWithDB fetchThoughtByInt:date];
    
    self.nbItems=[contents count];
    
    self.isLoadingAExistingTodayPlan = NO;
    
    
}

-(void)newPlanPreparation
{
    //initialize contents as array
    contents = [NSMutableArray array];
    //initialize an though obj
    self.ToCP04Thought = [[Thoughts alloc] init];
  
    self.nbItems=0;
    
    self.isLoadingAExistingTodayPlan = NO;
}
@end
