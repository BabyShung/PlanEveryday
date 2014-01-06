//
//  CP03ViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/11/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//
#import "ClockView.h"
#import "Category.h"
#import "TimeConverting.h"
#import "CP03ViewController.h"
#import "UICircularSlider.h"
#import "DCFineTuneSlider.h"
#import "OperationsWithDB.h"
//return msg
#import "SVProgressHUD.h"
//alertview
#import "UIAlertView+Blocks.h"
#import "DDAlertPrompt.h"
#import "LocalNotification.h"
@interface CP03ViewController ()

@property (nonatomic) NSInteger priorityNum;
@property (nonatomic) NSInteger selectedCategoryIndex;
@property (nonatomic) NSInteger sliderIntValueFixed;
@property (nonatomic) NSInteger spanClockwise;
@property (nonatomic) BOOL clockAMPMFlag;

@end

@implementation CP03ViewController

//lively clock
- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
}
///////
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
    self.priorityNum=self.CP03Event.Priority;
    if (self.priorityNum==0) {
        [defaultPickerView selectItemAtIndex:1 animated:NO];
        self.priorityNum=2;//normal
        defaultPickerView.itemColor = [UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000];
    }
    else
    {
        int index = self.priorityNum-1;
        [defaultPickerView selectItemAtIndex:index animated:NO];
        [self setColorForPriorityPicker:index];
    }
    
      

    //selector---category
    self.CP03Categories = [OperationsWithDB fetchCategory];
    Category *Cnil = [[Category alloc]init];
    Category *Cadd = [[Category alloc]init];
    Cnil.CName = @"Nil";
    Cadd.CName = @"Add";
    [self.CP03Categories insertObject:Cnil atIndex:0];
    [self.CP03Categories insertObject:Cadd atIndex:0];
    self.selectorHorizontal.dataSource = self;
    self.selectorHorizontal.delegate = self;
    self.selectorHorizontal.shouldBeTransparent = YES;
    self.selectorHorizontal.horizontalScrolling = YES;
    self.selectorHorizontal.debugEnabled = NO;
    NSLog(@"%@",self.CP03Event.Category);//first time will be null
 



    //set up clock view
    [self.ClockBackground setImage:[UIImage imageNamed:@"clockSlidingBG.png"]];
	[self.ClockCircleSlider addTarget:self action:@selector(SlideUpdate:) forControlEvents:UIControlEventValueChanged];
	[self.ClockCircleSlider setMinimumValue:self.ClockSlider.minimumValue];
	[self.ClockCircleSlider setMaximumValue:self.ClockSlider.maximumValue];
    

    //slider----------
    [self.ClockSlider.decreaseButton setImage:[UIImage imageNamed:@"SmallLeft.png"] forState:UIControlStateNormal];
	self.ClockSlider.decreaseButton.contentEdgeInsets = UIEdgeInsetsMake(1.0, 0, 0, 0);
    
	[self.ClockSlider.increaseButton setImage:[UIImage imageNamed:@"SmallRight.png"] forState:UIControlStateNormal];
	self.ClockSlider.increaseButton.contentEdgeInsets = UIEdgeInsetsMake(1.0, 0, 0, 0);
    
	self.ClockSlider.fineTuneAmount = 1;
	[self.view addSubview:self.ClockSlider];
    
    
    
    
    int value;
    int currentTimtValue= [TimeConverting CurrentTimeToSliderValue];
    if(self.CP03Event.Eid==0) //which means we are creating a new event
    {
        //just get current time value
        value = currentTimtValue;
    }
    else    //click did select delegate
    {   //update that time
        value = [TimeConverting IntegerTimeToSliderValue:self.CP03Event.StartTime];
    }
    
    //initialization------
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
    
    //assign the value, which will be used when sliding
    self.sliderIntValueFixed = value;
    self.spanClockwise = 720 - self.sliderIntValueFixed;
    
    [self UpdateExpectedTimeLabel:value];
    [self.ClockCircleSlider setValue:value];
    [self.ClockSlider setValue:value];
    //----------------------------------------------------
    
    self.TextField1.delegate=self;
    //passed value
    self.TextField1.text=self.CP03Event.Ename;
    
    //keyboard-----------------
    //toolbar data -----can be subtituded by your own data
    
    NSMutableArray *tmp = [OperationsWithDB fetchEventNamesWithLimits:5];
    if([tmp count]!=0)
    {
        self.toolbar = [[IGAutoCompletionToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        self.toolbar.items = tmp;
    }
    else    //empty
    {
        self.toolbar = [[IGAutoCompletionToolbar alloc] initWithFrame:CGRectMake(0,0,320,0)];
    }

    self.toolbar.toolbarDelegate = self;
    
    self.TextField1.inputAccessoryView = self.toolbar;
    
    self.toolbar.textField = self.TextField1;

    ///////////////////////
  
}




- (IBAction)DoneWithCP03View:(id)sender {
    
    if(!self.CP03Event)
    {
        self.CP03Event = [[Event alloc]init];
        NSLog(@"creating a new event Haha");
    }
    
    //calculate date -------*****
    int tmpInt = [TimeConverting SliderValueToIntegerEXPofDate:self.ClockSlider.value andAMPM:self.AMPMDisplay.text];
    
    NSLog(@"SliderValueToIntegerEXPofDate!!!!!!! :  %i",tmpInt);
    

    //possible changing vars.
    self.CP03Event.Ename=self.TextField1.text;
    self.CP03Event.StartTime=tmpInt;
    self.CP03Event.EndTime=0;
    self.CP03Event.Priority=self.priorityNum;
    self.CP03Event.Category=self.selectedCategory;
    self.CP03Event.IndexInDBCategory=self.selectedCategoryIndex;


    if(self.TextField1.text.length!=0)
    {
        if(self.CP03Event.didSelectAVirtualCell == NO)         //creating a new event
        {
            [SVProgressHUD showSuccessWithStatus:@"Event created!"];
            self.CP03Event.notificationID = [LocalNotification getUniqueNotificationID];
        }
        else    //modifying an event
        {
            [SVProgressHUD showSuccessWithStatus:@"Event modified!"];
        }
        
        //send back the Event to CP02
        [self.delegate passInfoback:self withEvent:self.CP03Event];
       
        //delay code
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        });
    }
    else
    {
        [UIAlertView showWarningWithMessage:@"Please enter an event name."
                                    handler:^(UIAlertView *alertView, NSInteger buttonIndex) {    
                                        NSLog(@"Warning dismissed");
                                    }];
    }
    
    
}
//-------------------------------------------------------------------------------------------



- (IBAction)AMPMbtnClicked:(id)sender {
    [self ChangeAMPM];
    
}
- (IBAction)SlideUpdate:(UISlider *)sender {    
    
    if(sender.value >= 720|| sender.value < 1)
    {
        [self ChangeAMPM];
    }
    [self UpdateExpectedTimeLabel:sender.value];//implicitly convert to int
    [self.ClockCircleSlider setValue:sender.value];
	[self.ClockSlider setValue:sender.value];
    self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeft:sender.value andAMPM:self.AMPMDisplay.text];
    
}

-(void)UpdateExpectedTimeLabel:(NSInteger) currentMinute
{

    int minuteInAHour = currentMinute%60;
    int exactHour = currentMinute/60;
    
    if (exactHour == 0 && [self.AMPMDisplay.text isEqualToString:@"PM"]) {
        exactHour = 12;
    }
    
    if (minuteInAHour<10) {
        self.ExpectedTime.text = [NSString stringWithFormat:@"%i:0%i %@",exactHour,minuteInAHour,self.AMPMDisplay.text];
    }
    else
    {
        self.ExpectedTime.text = [NSString stringWithFormat:@"%i:%i %@",exactHour,minuteInAHour,self.AMPMDisplay.text];
    }
}


- (void)ChangeAMPM{     //pressing AM/PM btn----------------

 
    [UIView animateWithDuration:1.0 animations:^{
        if([self.AMPMDisplay.text isEqualToString:@"AM"])
        {
            self.AMPMDisplay.text = @"PM";
            //1st, update left label
            [self UpdateExpectedTimeLabel:self.ClockCircleSlider.value];
            //2ed, update right label
            self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeft:self.ClockCircleSlider.value andAMPM:self.AMPMDisplay.text];
        }
        else
        {
            self.AMPMDisplay.text = @"AM";
            [self UpdateExpectedTimeLabel:self.ClockCircleSlider.value];
            self.CountHoursLeftLabel.text=[TimeConverting CountHoursLeft:self.ClockCircleSlider.value andAMPM:self.AMPMDisplay.text];
        }
    }];
}















//-------------------------------------------------------------------------------------------


#pragma IZValueSelector dataSource
- (NSInteger)numberOfRowsInSelector:(IZValueSelectorView *)valueSelector {
    return [self.CP03Categories count];
}

//ONLY ONE OF THESE WILL GET CALLED (DEPENDING ON the horizontalScrolling property Value)
- (CGFloat)rowHeightInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}

- (CGFloat)rowWidthInSelector:(IZValueSelectorView *)valueSelector {
    return 70.0;
}


- (UIView *)selector:(IZValueSelectorView *)valueSelector viewForRowAtIndex:(NSInteger)index
{
    Category *cag = [self.CP03Categories objectAtIndex:index];
    //uiview
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, self.selectorHorizontal.frame.size.height)];

    if(index==0)
    {
        //button
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, self.selectorHorizontal.frame.size.height)];
        
        [myView addSubview:btn];
        [btn addTarget:self action:@selector(CategoryBtnAdd:) forControlEvents:UIControlEventTouchDown];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitleColor:[UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000] forState:UIControlStateNormal];
        [btn setTitle:cag.CName forState:UIControlStateNormal];
        
        btn.tag = index;
        
        if(self.shouldCategoryToolBeDisabled ==YES)
        {
            btn.enabled = NO;
        }
    }
    else if(index==1)
    {
        //label
        UILabel * label = nil;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, self.selectorHorizontal.frame.size.height)];
        label.adjustsFontSizeToFitWidth = YES;        
        label.text = [NSString stringWithFormat:@"%@",cag.CName];
        label.textAlignment =  NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0];
        [label setTextColor:[UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0]];
        [myView addSubview:label];
    }
    else    //index > 1
    {
        //button
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, self.selectorHorizontal.frame.size.height)];
    
        [myView addSubview:btn];
        [btn addTarget:self action:@selector(CategoryBtnModify:) forControlEvents:UIControlEventTouchDown];
        [btn setTitle:cag.CName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.tag = index;
        
        if(self.shouldCategoryToolBeDisabled ==YES)
        {
            btn.enabled = NO;
        }
    }
    return myView;
}
//-----------catetory field---------------------------------------------------------------
- (void)CategoryBtnModify:(id)sender
{
    UIButton *tmp =sender;
    DDAlertPrompt *loginPrompt = [[DDAlertPrompt alloc] initWithTitle:@"Edit my category" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Modify" andCategoryName:tmp.titleLabel.text andindexInArray:tmp.tag];
	[loginPrompt show];
}

- (void)CategoryBtnAdd:(id)sender
{
    DDAlertPrompt *loginPrompt = [[DDAlertPrompt alloc] initWithTitle:@"Add a category" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Save" andCategoryName:nil andindexInArray:0];
	[loginPrompt show];
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([alertView isKindOfClass:[DDAlertPrompt class]])
    {
		DDAlertPrompt *loginPrompt = (DDAlertPrompt *)alertView;
		[loginPrompt.plainTextField becomeFirstResponder];
		[loginPrompt setNeedsLayout];
	}
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView cancelButtonIndex])
    {
	}
    else
    {
		if ([alertView isKindOfClass:[DDAlertPrompt class]])
        {            
			DDAlertPrompt *loginPrompt = (DDAlertPrompt *)alertView;
            int indexInArray = loginPrompt.indexInMutableArray;
            
            Category *tmpC =[[Category alloc] init];
            tmpC.CName = loginPrompt.plainTextField.text;
            
            Category *tmpOld =[[Category alloc] init];
            tmpOld = [self.CP03Categories objectAtIndex:indexInArray];
            
            if(indexInArray>1)
            {
                //modify array     
                [self.CP03Categories replaceObjectAtIndex:indexInArray withObject:tmpC];
                //reload
                [self.selectorHorizontal reloadData];
                //update in DB
                [OperationsWithDB UpdateIntoCategoryTable:tmpC andOld:tmpOld];
                //
            }
            else if(indexInArray == 0)  //add a category
            {
                //modify array
                [self.CP03Categories insertObject:tmpC atIndex:2];
                //reload
                [self.selectorHorizontal reloadData];
                //update in DB
                [OperationsWithDB InsertIntoCategoryTable:tmpC];
            }
            
            
            
            
		}
	}
}

- (CGRect)rectForSelectionInSelector:(IZValueSelectorView *)valueSelector {

        return CGRectMake(self.selectorHorizontal.frame.size.width/2 - 35.0, 0.0, 70.0, 90.0);
        NSLog(@"----??");
    
}
//------------------------------------------------------------------------------------
#pragma IZValueSelector delegate
-(void)passTableReference:(UITableView *)valueSelector  //hao defined
{
    //has to solve the inconsistency,since I add 'add' and nil at the front,so +2
    NSIndexPath * tmpIP = [NSIndexPath indexPathForRow:self.CP03Event.IndexInDBCategory+2 inSection:0];
    if(tmpIP.row != 2)
    {
        [self.selectorHorizontal.contentTableView  scrollToRowAtIndexPath:tmpIP atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    else
    {
        [self.selectorHorizontal.contentTableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    self.selectedCategory=self.CP03Event.Category;
    self.selectedCategoryIndex=self.CP03Event.IndexInDBCategory;

}

- (void)selector:(IZValueSelectorView *)valueSelector didSelectRowAtIndex:(NSInteger)index {
    Category *cag = [self.CP03Categories objectAtIndex:index];
    self.selectedCategory=cag.CName;
    self.selectedCategoryIndex=index;
    NSLog(@"%@", self.selectedCategory);
    NSLog(@"Selected index %d",index);
}

#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 3;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    if(item==0)
    {
        return [NSString stringWithFormat:@"Trivial"];
    }
    else if (item==1)
    {
        return [NSString stringWithFormat:@"Normal"];
    }
    else
    {
        return [NSString stringWithFormat:@"Urgent"];
    }
    
}




#pragma mark - CPPickerViewDelegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    [self setColorForPriorityPicker:item];
    self.priorityNum = item + 1;
}
-(void)setColorForPriorityPicker:(NSInteger) item
{
    if(item == 1)   //green
    {
        defaultPickerView.itemColor = [UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000];
    }
    else if (item == 2) //red
    {
        defaultPickerView.itemColor = [UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0];
    }
    else    //item = 0  orange
    {
        defaultPickerView.itemColor = [UIColor orangeColor];
    }
}

//textfield-----------
//delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)TapOnce:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    NSLog(@"tapped");
}

- (IBAction)BackBTN:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - KeyBoardDelegate
- (void) autoCompletionToolbar:(IGAutoCompletionToolbar*)toolbar didSelectItemWithObject:(id)object
{
    self.TextField1.text=[NSString stringWithFormat:@"%@",object];
    NSLog(@"tag selected - %@", object);
}

@end
