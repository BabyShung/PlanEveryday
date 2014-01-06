//
//  AC01ViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 5/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "AC01ViewController.h"
#import "MCSwipeTableViewCell.h"
#import "OperationsWithDB.h"
#import "TimeConverting.h"
#import "AC02ViewController.h"
#import "LocalNotification.h"
@interface AC01ViewController () <MCSwipeTableViewCellDelegate>

@property(nonatomic, assign) NSUInteger nbItems;

@property (nonatomic, assign) BOOL DeleteRowFlag;

@end

@implementation AC01ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.AC01TableView.delegate=self;
    self.AC01TableView.dataSource=self;
 
    //anyway, it will return an instantiated obj
    contents = [OperationsWithDB fetchAlarms];
    self.nbItems=[contents count];
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DismissAC01:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //refresh main view
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMainView" object:nil];
}
- (IBAction)DoneWithAC01:(id)sender {
    //refresh table and reset the topview
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MainNC" object:nil];
    //dismiss the current presenting view
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}
//coming back from AC02
-(void) passInfoback:(AC02ViewController *)controller withAlarm:(Alarm *)alarm andIsUpdate:(BOOL)isUpdate
{
    NSLog(@"come back from AC02");

    if(isUpdate== YES)   //a modified cell,no need to increment nbitems
    {
        [contents removeObjectAtIndex:alarm.IndexInSwipeTable];
        [contents insertObject:alarm atIndex:alarm.IndexInSwipeTable];
    }
    else
    {
        [contents addObject:alarm];
        //increment events
        self.nbItems++;
    }
    
    [self.AC01TableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}



         
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
        [cell.textLabel setText:@"Add an alarm clock?"];
    }
    else    //there are >0 Alarms
    {
        //get the obj
        Alarm *tmp = [contents objectAtIndex:indexPath.row];
        
        //add a switch
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(222, 16, 0, 0)];
        

        switchView.tag = indexPath.row;

        NSLog(@"switch : %i",switchView.tag);
        NSLog(@"tmp.enabled : %i",tmp.enabled);
       
        [switchView setOn:tmp.enabled animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell addSubview:switchView];
        
        
        
        //convert time from int to string
        NSString *finalTimeString = [TimeConverting TimeIntToString:tmp.AlarmTime];
        NSString *result = [NSString stringWithFormat:@"%@",finalTimeString];
        [cell.textLabel setText:result];
        
        if(![tmp.Label isEqualToString:@"(null)"])
        {
            [cell.detailTextLabel setText:tmp.Label];
        }
        [cell setMode:MCSwipeTableViewCellModeExit];
        

        
        
    }
    return cell;
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    Alarm *currentAlarm;
    
    if(switchControl.isOn == NO)    //means from On to Off,so has to cancel a notification
    {
                
        currentAlarm = [contents objectAtIndex:switchControl.tag];
        
        currentAlarm.enabled = NO;
        
        [LocalNotification CancelExistingNotification:currentAlarm.notificationID];
        
    }
    else if(switchControl.isOn == YES)  //means from off to on, so has to set up a notification
    {
             
        currentAlarm = [contents objectAtIndex:switchControl.tag];
        
        currentAlarm.enabled = YES;
        
        [LocalNotification scheduleLocalNotificationWithDate:[TimeConverting getNSDateFromInt:currentAlarm.AlarmTime] atIndex:currentAlarm.notificationID andAlertBody:@"Alarm" andAlertAction:@"Open App"];
        
    }
    
    //no matter what you did, update on/off in the db
    NSLog(@"currentAlarm.ACid: %i",currentAlarm.ACid);
    NSLog(@"currentAlarm.enabled: %i",currentAlarm.enabled);
    [OperationsWithDB UpdateJustEnabledOfAlarmTable:currentAlarm];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    return 60.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.nbItems!=0)
    {  
        Alarm *alr=[contents objectAtIndex:indexPath.row];
        int TBindex = indexPath.row;
        alr.IndexInSwipeTable = TBindex;
        self.ToAC02Alarm=alr;
        [self performSegueWithIdentifier:@"DidSelect" sender:self];
    } 
    //deselect the lines background
    [self.AC01TableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"DidSelect"])
    {
        AC02ViewController *ac02=[segue destinationViewController];
        ac02.AC02Alarm = self.ToAC02Alarm;
        ac02.delegate = self;
    }
    else    //add a new alarm
    {
        AC02ViewController *ac02=[segue destinationViewController];
        ac02.delegate = self;
    }
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode {
    
    if (mode == MCSwipeTableViewCellModeExit)
    {
        int index = [self.AC01TableView indexPathForCell:cell].row;
        
        Alarm *tmp =[contents objectAtIndex:index];
        NSLog(@"ACid %i",tmp.ACid);
        
        [OperationsWithDB deleteAnAlarm:tmp];
  
        //also cancel (if already set) the notification
        if(tmp.enabled == YES)
        {
            [LocalNotification CancelExistingNotification:tmp.notificationID];
        }
        
        //also,contents array will remove an alarm object
        [contents removeObjectAtIndex:index];
        
        //row decrement
        if(self.nbItems==1) //in order to solve the inconsistency
        {
            self.DeleteRowFlag=YES;
        }
        
        self.nbItems--;
        
        [self.AC01TableView deleteRowsAtIndexPaths:@[[self.AC01TableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];   
    }
}


@end
