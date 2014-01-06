//
//  CalendarViewController.m
//  PlanEveryday
//
//  Created by Hongye Wang on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "CalendarViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "JHActivityButton.h"
#import "OperationsWithDB.h"
@interface CalendarViewController ()

@end

@implementation CalendarViewController

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
    [self Preparations];
    
    [self.monthView selectDate:[NSDate date]];
    
    
    //----------------------------
    float y,height;
	y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	height = self.view.frame.size.height - y;
    
	
    //the table view beneath the grids
    self.MyView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, height)];
    
    self.MyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    
	[self.view addSubview:self.MyView];
	[self.view sendSubviewToBack:self.MyView];
    
    
    
    
    CGFloat xLoc = 30;
    
    [[JHActivityButton appearance]setAnimationTime:0.5];
    
    for (int i=0; i<2; i++){
        
        JHActivityButton* activityButton = [[JHActivityButton alloc]initFrame:CGRectMake(xLoc, 40, 100, 50) style:10];
        [activityButton setBackgroundColor:[UIColor colorWithRed:223/255.0f green:222/255.0f blue:225/255.0f alpha:1.0] forState:UIControlStateNormal];
        [activityButton setBackgroundColor:[UIColor colorWithRed:223/255.0f green:222/255.0f blue:225/255.0f alpha:0] forState:UIControlStateSelected];
        
        [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [activityButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        /** the bounds of the title label is always limited to the bounds of the original button size before expansion */
        if(i == 0)
        {
            //self.leftBtn = activityButton;
            [activityButton setTitle:@"Create" forState:UIControlStateNormal];
            [activityButton setTitle:@"22" forState:UIControlStateSelected];
            // Add target to Button
            
        }
        else if( i == 1 )
        {
            //self.RightBtn = activityButton;
            [activityButton setTitle:@"Detail" forState:UIControlStateNormal];
            [activityButton setTitle:@"22" forState:UIControlStateSelected];
            [activityButton addTarget:self action:@selector(didClickDetailBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        activityButton.layer.shadowColor = [UIColor blackColor].CGColor;
        activityButton.layer.shadowOffset = CGSizeMake(3, 3);
        activityButton.layer.shadowOpacity = 0.6;
        activityButton.layer.shadowRadius = 1.0;
        activityButton.clipsToBounds = NO;
        activityButton.userInteractionEnabled = YES;
        //activityButton.enabled = NO;
        
        
        [activityButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22]];
        
        [activityButton.indicator setColor:[UIColor whiteColor]];
        
        [self.MyView addSubview:activityButton];
        
        xLoc += 160;
    }

    
}


-(void)didClickDetailBtn
{
    //slide
    [self.slidingViewController anchorTopViewTo:ECLeft animations:NO onComplete:nil];

}


#pragma mark MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    
	[self fetchDataForStartDate:startDate endDate:lastDate];
	return self.dataArray;
}




- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	NSLog(@"Date Selected by hao : %@",date);
    
    int tempPid = [OperationsWithDB fetchPidByCreateDate:date];
    //reload a specific plan
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAPlan" object:self userInfo:@{@"key":[NSNumber numberWithInt:tempPid]}];
    
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	//[self.tableView reloadData];
}


#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *ar = self.dataEvents[[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}

- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];    
	
    
	NSArray *ar = self.dataEvents[[self.monthView dateSelected]];
	cell.textLabel.text = ar[indexPath.row];
	
    return cell;
	
}


- (void) fetchDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	
	NSLog(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
	self.dataArray = [NSMutableArray array];
	self.dataEvents = [NSMutableDictionary dictionary];
	
	NSDate *d = start;
	while(YES)
    {
        
        contents = [OperationsWithDB fetchEvents:d];
        
        if ([contents count]>0)
        {
            NSMutableArray *values = [NSMutableArray array];
            [self.dataEvents setObject:values forKey:d];
            Event *evt = [contents objectAtIndex:0];
            NSString *val = [NSString stringWithFormat:@"%@", evt.Ename];
            [[self.dataEvents objectForKey:d] addObject:val];
            
            for (int i=1; i<[contents count]; i++){
                Event *evt = [contents objectAtIndex:i];
                NSString *val = [NSString stringWithFormat:@"%@", evt.Ename];
                
                [[self.dataEvents objectForKey:d] addObject:val];
            }
            
			//[self.dataEvents setObject:@[tmp] forKey:d];
			[self.dataArray addObject:@YES];
            
		}
        else
        {
            [self.dataArray addObject:@NO];
        }
        
        
		NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
		d = [NSDate dateWithDateComponents:info];
		if([d compare:end]==NSOrderedDescending) break;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LeftToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)RightToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

@end
