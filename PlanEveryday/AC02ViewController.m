//
//  AC02ViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 5/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//
#import "PLAppDelegate.h"

#import <AudioToolbox/AudioToolbox.h>


#import "Alarm.h"
#import "AC02ViewController.h"
#import "ClockView.h"
#import "TimeConverting.h"
#import "UICircularSlider.h"
#import "DCFineTuneSlider.h"
#import "OperationsWithDB.h"
//return msg
#import "SVProgressHUD.h"
#import "LocalNotification.h"
@interface AC02ViewController ()
 
@property (nonatomic) NSInteger Repeatence;
@end

@implementation AC02ViewController


- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
}

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
	
    //priority picker
    defaultPickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(10, 115.0, 140, 40)];
    defaultPickerView.backgroundColor = [UIColor whiteColor];
    defaultPickerView.dataSource = self;
    defaultPickerView.delegate = self;
    defaultPickerView.itemFont= [UIFont boldSystemFontOfSize:16];
    defaultPickerView.peekInset = UIEdgeInsetsMake(0, 30, 0, 30);
    [defaultPickerView reloadData];
    [self.view addSubview:defaultPickerView];
    
    //pick 1
    self.Repeatence=self.AC02Alarm.Repeatence;
    if (self.Repeatence==0) {
        [defaultPickerView selectItemAtIndex:0 animated:NO];
        self.Repeatence=1;//normal
    }
    else
    {
        int index = self.Repeatence-1;
        [defaultPickerView selectItemAtIndex:index animated:NO];
    }

    
    
    
    //set up clock view
    [self.ClockBackground setImage:[UIImage imageNamed:@"clockSlidingBG.png"]];
	[self.ClockCircleSlider addTarget:self action:@selector(SlideUpdate:) forControlEvents:UIControlEventValueChanged];
	[self.ClockCircleSlider setMinimumValue:self.ClockSlider.minimumValue];
	[self.ClockCircleSlider setMaximumValue:self.ClockSlider.maximumValue];
    
    
    //slider
    [self.ClockSlider.decreaseButton setImage:[UIImage imageNamed:@"SmallLeft.png"] forState:UIControlStateNormal];
	self.ClockSlider.decreaseButton.contentEdgeInsets = UIEdgeInsetsMake(1.0, 0, 0, 0);
    
	[self.ClockSlider.increaseButton setImage:[UIImage imageNamed:@"SmallRight.png"] forState:UIControlStateNormal];
	self.ClockSlider.increaseButton.contentEdgeInsets = UIEdgeInsetsMake(1.0, 0, 0, 0);
    
	self.ClockSlider.fineTuneAmount = 1;
	[self.view addSubview:self.ClockSlider];
    
    
    
    
    int value;
    int currentTimtValue= [TimeConverting CurrentTimeToSliderValue];
    if(self.AC02Alarm.AlarmTime==0)
    {
        value = currentTimtValue;
    }
    else    //click did select delegate
    {   //update that time
        int hour = self.AC02Alarm.AlarmTime/100;
        int minute = self.AC02Alarm.AlarmTime%100;
        value=hour*60+minute;
    }
    //check value
    if(value>=720)
    {
        self.AMPMDisplay.text = @"PM";
    }
    else
    {
        self.AMPMDisplay.text = @"AM";
    }
    value%=720;
    
    
    [self UpdateExpectedTimeLabel:value];
    [self.ClockCircleSlider setValue:value];
    [self.ClockSlider setValue:value];

    
    
    
    //textField--label
    self.TextField1.delegate=self;
    //passed value
    if([self.AC02Alarm.Label isEqualToString:@"(null)"])
    {
        self.TextField1.text = @"";
    }
    else
    {
        self.TextField1.text=self.AC02Alarm.Label;
    }
}


- (IBAction)DismissAC02:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)DoneWithAC02:(id)sender {
    if(!self.AC02Alarm)
    {
        self.AC02Alarm = [[Alarm alloc]init];
    }
    
    
    //get int date to store in db
    int tmpInt = [TimeConverting SliderValueToIntegerEXPofDate:self.ClockSlider.value andAMPM:self.AMPMDisplay.text];

    
    self.AC02Alarm.Label = self.TextField1.text;
    self.AC02Alarm.AlarmTime = tmpInt;
    
    //bug!
    NSLog(@"tmpInt time ** ** ** ** ** ** minutes unit : %i",tmpInt);
    
    self.AC02Alarm.Repeatence = self.Repeatence;
    self.AC02Alarm.enabled = YES;
    
    NSLog(@"calling method - tmp.notificationID: %i",self.AC02Alarm.notificationID);
    //tmp.PickedSong
 
    
    if(self.AC02Alarm.ACid==0) //this is a new alarm setting
    {
        self.AC02Alarm.notificationID = [LocalNotification getUniqueNotificationID];
        
        [SVProgressHUD showSuccessWithStatus:@"Alarm created!"];
        
        //DIY set local notification
        [LocalNotification scheduleLocalNotificationWithDate:[TimeConverting getNSDateFromInt:self.AC02Alarm.AlarmTime] atIndex:self.AC02Alarm.notificationID andAlertBody:@"Alarm" andAlertAction:@"Open App"];
        
        //create a new one in the db
        int returnID = [OperationsWithDB InsertIntoAlarmTable:self.AC02Alarm];
        self.AC02Alarm.ACid = returnID;
        [self.delegate passInfoback:self withAlarm:self.AC02Alarm andIsUpdate:NO];
    }
    else    //existing alarm
    {

        
        [SVProgressHUD showSuccessWithStatus:@"Alarm modified!"];
        
        [LocalNotification CancelExistingNotification:self.AC02Alarm.notificationID];
        
        
        
        //DIY set local notification
        [LocalNotification scheduleLocalNotificationWithDate:[TimeConverting getNSDateFromInt:self.AC02Alarm.AlarmTime] atIndex:self.AC02Alarm.notificationID andAlertBody:@"Alarm" andAlertAction:@"Open App"];
        
        
        
        //update the original one
        [OperationsWithDB UpdateIntoAlarmTable:self.AC02Alarm];
        [self.delegate passInfoback:self withAlarm:self.AC02Alarm andIsUpdate:YES];
    }

    
    
    //delay code
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    });
    
    
}

 



//----------------------------------------------------------
- (IBAction)SlideUpdate:(UISlider *)sender {
    
    int currentTimtValue= [TimeConverting CurrentTimeToSliderValue];
    
    if(currentTimtValue>=720)    //
    {
        currentTimtValue=currentTimtValue-720;
    }
    if(sender.value<currentTimtValue)
    {
        [self ChangeAMPMFunction2];
    }
    else
    {
        [self ChangeAMPMFunction3];
    }
    
    [self UpdateExpectedTimeLabel:sender.value];//implicitly convert to int
    [self.ClockCircleSlider setValue:sender.value];
	[self.ClockSlider setValue:sender.value];
    self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeftForAlarmClock:sender.value andAMPM:self.AMPMDisplay.text];
}
 

-(void)ChangeAMPMFunction2
{
    [UIView animateWithDuration:1.0 animations:^{
        
        int currentTimtValue= [TimeConverting CurrentTimeToSliderValue];
        if(currentTimtValue>=720)   //pm
        {
            if([self.AMPMDisplay.text isEqualToString:@"PM"])
            {
                self.AMPMDisplay.text = @"AM";
                [self UpdateExpectedTimeLabel:self.ClockCircleSlider.value];
                self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeftForAlarmClock: self.ClockCircleSlider.value andAMPM:self.AMPMDisplay.text];
            }
            else
            {
                //nothing
            }     
        }
        else    //am
        {
            if([self.AMPMDisplay.text isEqualToString:@"AM"])
            {
                self.AMPMDisplay.text = @"PM";
                [self UpdateExpectedTimeLabel:self.ClockCircleSlider.value];
                self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeftForAlarmClock: self.ClockCircleSlider.value andAMPM:self.AMPMDisplay.text];
            }
            else
            {
                //nothing
            }

        }
    }];
}

-(void)ChangeAMPMFunction3
{
    [UIView animateWithDuration:1.0 animations:^{
        
        int currentTimtValue= [TimeConverting CurrentTimeToSliderValue];
        NSLog(@"yyy %i",currentTimtValue);
        if(currentTimtValue>=720)   //pm
        {
                self.AMPMDisplay.text = @"PM";
                [self UpdateExpectedTimeLabel:self.ClockCircleSlider.value];
                 self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeftForAlarmClock: self.ClockCircleSlider.value andAMPM:self.AMPMDisplay.text];     
        }
        else    //am
        {
                self.AMPMDisplay.text = @"AM";
                [self UpdateExpectedTimeLabel:self.ClockCircleSlider.value];
                 self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeftForAlarmClock: self.ClockCircleSlider.value andAMPM:self.AMPMDisplay.text];          
        }  
    }];
}


-(void)UpdateExpectedTimeLabel:(NSInteger) currentMinute
{
    int minuteInAHour = currentMinute%60;
    int exactHour = currentMinute/60;
    
    if (exactHour == 0 && [self.AMPMDisplay.text isEqualToString:@"PM"]) {
        exactHour = 12;
    }
    
    if (minuteInAHour<10) {
        self.ExpectedTime.text = [NSString stringWithFormat:@"Set to: %i:0%i %@",exactHour,minuteInAHour,self.AMPMDisplay.text];
    }
    else
    {
        self.ExpectedTime.text = [NSString stringWithFormat:@"Set to: %i:%i %@",exactHour,minuteInAHour,self.AMPMDisplay.text];
    }
}


#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 8;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    if(item==0)
    {
        return [NSString stringWithFormat:@"Never"];
    }
    else if (item==1)
    {
        return [NSString stringWithFormat:@"Monday"];
    }
    else if (item==2)
    {
        return [NSString stringWithFormat:@"Tuesday"];
    }
    else if (item==3)
    {
        return [NSString stringWithFormat:@"Wednesday"];
    }
    else if (item==4)
    {
        return [NSString stringWithFormat:@"Thursday"];
    }
    else if (item==5)
    {
        return [NSString stringWithFormat:@"Friday"];
    }
    else if (item==6)
    {
        return [NSString stringWithFormat:@"Saturday"];
    }
    else
    {
        return [NSString stringWithFormat:@"Sunday"];
    }
    
}




#pragma mark - CPPickerViewDelegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
     self.Repeatence = item + 1;
}

//delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)TapOnce:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    NSLog(@"tapped");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
