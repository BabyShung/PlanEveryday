//
//  CP01ViewController.m
//  FaceBookNav2
//
//  Created by Hao Zheng on 4/1/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "CP01ViewController.h"

#import "Plan.h"

#import "OperationsWithDB.h"
//flip number
#import "JDFlipNumberView.h"
#import "JDDateCountdownFlipView.h"
#import "UIFont+FlipNumberViewExample.h"
#import "TimeConverting.h"

#import "JSNotifier.h"

#import "CP02ViewController.h"
static CGFloat const FVEDetailControllerTargetedViewTag = 111;


@interface CP01ViewController () <JDFlipNumberViewDelegate>

- (void)showMultipleDigits;

@end

@implementation CP01ViewController

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

    //nsNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissHao) name:@"CP01NC" object:nil];

    
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];

    /////
    
    [super viewDidLoad];
    
    //flip number    
    [self showMultipleDigits];  //great
    
    
    
    //prepare picker view
    [self prepareAFpicker];
    
}


-(void)prepareAFpicker{
    //data  ---- can be substituded by your own data
    daysData = [NSMutableArray array];
    
    [daysData addObject:@"A New Plan"];
    
    daysDataIntValue = [OperationsWithDB fetchPlansWithLimits:5 butExceptToday:[NSDate date]];
     
    for(Plan *p in daysDataIntValue)
    {        
        NSString *finalString = [TimeConverting TimeDateINTToString2:p.CreateDate];
        [daysData addObject:finalString];
    }
    
    
    //picker ordinate+width+height
    daysPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(60, 60.0, 200.0, 197.0)];
    daysPickerView.dataSource = self;
    daysPickerView.delegate = self;
    daysPickerView.rowFont = [UIFont boldSystemFontOfSize:19.0];
    daysPickerView.rowIndent = 10.0;
    [daysPickerView reloadData];
    [self.view addSubview:daysPickerView];
    
    //first time show in the label
    self.DisplayLabel.text = [daysData objectAtIndex:0];
    
}


#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    return [daysData count];
}

- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [daysData objectAtIndex:row];
}

#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    [UIView animateWithDuration:1.0 animations:^{
        if(row==0)
        {
            self.DisplayLabel.text = [daysData objectAtIndex:row];
        }
        else
        {
            //get a substring from the picker content
            NSRange range1 = NSMakeRange(5,8);
            NSString *subString1 = [[daysData objectAtIndex:row] substringWithRange:range1];
            self.DisplayLabel.text = [@"Use plan: " stringByAppendingString:subString1];
            
            
            //since added "a new plan" at the top,others are integer
            Plan *tmpP = [daysDataIntValue objectAtIndex:row-1];
            
            NSMutableArray *tmpArray = [OperationsWithDB fetchEventNamesByPid:tmpP.Pid];

            
            JSNotifier *notify = [[JSNotifier alloc]initWithTitleByHao:tmpArray andDate:subString1];
            [notify showFor:1.6*[tmpArray count]];
            
            
            
 
            self.ToCP02choseDate = tmpP.CreateDate;

        }
    }];
}

#pragma mark - flip number methods

- (void)showMultipleDigits;
{
    JDFlipNumberView *flipView = nil;
    
    //tageted termination animation
    
    //create 3 digit views
    flipView = [[JDFlipNumberView alloc] initWithDigitCount:3];
    
    
    flipView.value = 0;  //initialized value
    
    flipView.tag = FVEDetailControllerTargetedViewTag;
    
    
    
    //count how many plans the user has made
    int countPlan = [OperationsWithDB PlanHaveMade];
    if (countPlan == 0)
    {
        self.infoLabel.text = @"Welcome,your first time!";
    }
    else if(countPlan == 1)
    {
        self.infoLabel.text = [NSString stringWithFormat:@"You've made %i plan!",countPlan];
    }
    else
    {
        self.infoLabel.text = [NSString stringWithFormat:@"You've made %i plans!",countPlan];
    }
    
    NSInteger targetValue = countPlan;   //taget value, substitude by your own data
    
    NSDate *startDate = [NSDate date];
    
    [flipView animateToValue:targetValue duration:2.50 completion:^(BOOL finished) {
        if (finished)
        {
            NSLog(@"Animation needed: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        }
        else
        {
            NSLog(@"Animation canceled after: %.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
        }
        
        [self flipNumberView:flipView didChangeValueAnimated:finished];
    }];
    [self flipNumberView:flipView willChangeToValue:targetValue];
    
    
    [self.view addSubview: flipView];
    self.flipView = flipView;
}
  
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if (!self.flipView) {
        return;
    }
    
    self.flipView.frame = CGRectInset(self.view.bounds, 20, 20);
    self.flipView.center = CGPointMake(floor(self.view.frame.size.width/2),floor((self.view.frame.size.height/2)*1.5));
}

 

#pragma mark delegate

- (void)flipNumberView:(JDFlipNumberView*)flipNumberView willChangeToValue:(NSUInteger)newValue;
{
    //self.infoLabel.text = [NSString stringWithFormat: @"Will animate to %d", newValue];
}

- (void)flipNumberView:(JDFlipNumberView*)flipNumberView didChangeValueAnimated:(BOOL)animated;
{
   // self.infoLabel.text = [NSString stringWithFormat: @"Finished animation to %d.", flipNumberView.value];
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (IBAction)DismissCP01:(id)sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
    
    
   [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //refresh main view
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMainView" object:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"CP01toCP02"])
    {
        CP02ViewController *cp02=(CP02ViewController *)segue.destinationViewController;
        cp02.chosePlan=self.DisplayLabel.text;
        cp02.choseDate=self.ToCP02choseDate;
        NSLog(@"key----%@",cp02.chosePlan);
    }
}

-(void)dismissHao
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"dismissHao----");
}

 
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CP01NC" object:nil];
}

@end
