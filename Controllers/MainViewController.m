//
//  MainViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//


//hao
#import "NSDate+TCUtils.h"
#import "TimeConverting.h"
#import "OperationsWithDB.h"
#import "Event.h"
#import "MainViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "ViewDayViewController.h"
#import "AITicker.h"
#import "TDBadgedCell.h"
#import "CLTickerView.h"
@interface MainViewController ()

@property(nonatomic, assign) NSUInteger counterForView1;
@property(nonatomic, assign) NSUInteger counterForView2;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self Preparations];
    
    [self setCollapseClick];
    
    [self prepareSubview];
    
    self.myCollapseClick.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAPlan" object:self userInfo:@{@"key":[NSNumber numberWithInt:-1]}];
    
    
	// leftright ticker
    CLTickerView *ticker = [[CLTickerView alloc] initWithFrame:CGRectMake(0, 45, 320, 30)];
    NSString *front = [AITicker Greetings];
    NSString *Hdate = [TimeConverting transfromNSDATEtoNSString3:[NSDate date]];
    NSString *middle = [AITicker UpcomingEventOfTodayPlan:[NSDate date]];
    NSString *third = [AITicker getNumberOfTodayPlan:[NSDate date]];

    
    ticker.marqueeStr = [NSString stringWithFormat:@"%@%@. %@%@",front,Hdate,middle,third];
    ticker.marqueeFont = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:ticker];


}

-(void)prepareSubview
{

    self.MainSubTableView1.delegate=self;
    self.MainSubTableView1.dataSource=self;
    self.MainSubTableView2.delegate=self;
    self.MainSubTableView2.dataSource=self;
	
    //db operation
    NSLog(@"%@",[NSDate date]);
    NSLog(@"%@",[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:+1]);
    contents = [OperationsWithDB fetchEvents:[NSDate date]];
    contents2 = [OperationsWithDB fetchEvents:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:+1]];
 
}


#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.MainSubTableView1)
    {
        if ([contents count]==0) {
            self.counterForView1=0;
            [self resetViewHeight:60 andObj:tableView];
            return 1;
        }
        else if([contents count]==1) {
            self.counterForView1=1;
            [self resetViewHeight:60 andObj:tableView];
            return self.counterForView1;
        }
        else if([contents count]==2) {
            self.counterForView1=2;
            [self resetViewHeight:120 andObj:tableView];
            return self.counterForView1;
        }
        else if([contents count]==3) {
            self.counterForView1=3;
            [self resetViewHeight:180 andObj:tableView];
            return self.counterForView1;
        }
        else
        {
            self.counterForView1=[contents count];
            //[self resetViewHeight:60*self.counter andObj:tableView];
            return self.counterForView1;
        }
    }
    else    //mainsubview2
    {
        if ([contents2 count]==0) {
            self.counterForView2=0;
            [self resetViewHeight:60 andObj:tableView];
            return 1;
        }
        else if([contents2 count]==1) {
            self.counterForView2=1;
            [self resetViewHeight:60 andObj:tableView];
            return self.counterForView2;
        }
        else if([contents2 count]==2) {
            self.counterForView2=2;
            [self resetViewHeight:120 andObj:tableView];
            return self.counterForView2;
        }
        else if([contents2 count]==3) {
            self.counterForView2=3;
            [self resetViewHeight:180 andObj:tableView];
            return self.counterForView2;
        }
        else
        {
            self.counterForView2=[contents2 count];
            //[self resetViewHeight:60*self.counter andObj:tableView];
            return self.counterForView2;
        }

    }

}

-(void)resetViewHeight:(NSInteger)tmp andObj:(UITableView *)table
{
    CGRect tbFrame = [table frame];
    tbFrame.size.height = tmp;
    [table setFrame:tbFrame];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if(self.MainSubTableView1==tableView)
    {
    
      if(self.counterForView1==0)
      {
          cell.textLabel.text = [NSString stringWithFormat:@"No Event today,create one?"];
      }
      else
      {
          Event *tmp = [contents objectAtIndex:indexPath.row];
          //1.get event name
          cell.textLabel.text = tmp.Ename;
          //2.check category isNil
          if(![tmp.Category isEqualToString:@"Nil"]&&![tmp.Category isEqualToString:@"(null)"])
          {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tmp.Category];
          }
          
          //3.get starttime
          NSString *timeString=[TimeConverting TimeIntToString:tmp.StartTime];
          cell.badgeString = timeString;
        
          
          if(![TimeConverting EventTimeIsExpired:tmp.StartTime])
          {
              if(tmp.Priority == 2)
              {
                  cell.badgeColor = [UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000];
              }
              else if (tmp.Priority == 3)
              {
                  cell.badgeColor = [UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0];
              }
              else  //1
                {
                    cell.badgeColor = [UIColor orangeColor];
                }
        }
        else    //expired
            cell.badgeColor = [UIColor grayColor];
        
          
      }
 
    }
    else    //mainsubview 2
    {
        NSLog(@"self.counterForView2 %i",self.counterForView2);
        if(self.counterForView2==0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"No Event tomorrow,create one?"];
        }
        else
        {
            
            Event *tmp = [contents2 objectAtIndex:indexPath.row];
            //data
            cell.textLabel.text = tmp.Ename;
            if(![tmp.Category isEqualToString:@"Nil"]&&![tmp.Category isEqualToString:@"(null)"])
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tmp.Category];
            }
            
            NSString *timeString=[TimeConverting TimeIntToString:tmp.StartTime];
            cell.badgeString = timeString;
            
            
            if(![TimeConverting EventTimeIsExpired:tmp.StartTime])
            {
                if(tmp.Priority == 2)
                {
                    cell.badgeColor = [UIColor colorWithRed:0.197 green:0.592 blue:0.219 alpha:1.000];
                }
                else if (tmp.Priority == 3)
                {
                    cell.badgeColor = [UIColor colorWithRed:225/255.0f green:6/255.0f blue:2/255.0f alpha:1.0];
                }
                else  //1
                {
                    cell.badgeColor = [UIColor orangeColor];
                }
            }
            else    //expired
                cell.badgeColor = [UIColor grayColor];
            
            
        }

    }
    
    
    //settings
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.badge.fontSize = 16;
    cell.badgeLeftOffset = 8;
    cell.badgeRightOffset = 40;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    return 60.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.MainSubTableView1==tableView)
    {
        if(self.counterForView1==0)
        {
            UIViewController *newTopViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"Create Plans"];
            [self presentViewController:newTopViewController animated:YES completion:nil];
        }
        else    //detail view?
        {
            //[self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:NO onComplete:nil];
            [self.slidingViewController anchorTopViewTo:ECLeft animations:NO onComplete:nil];
        }
    }
    else
    {
        if(self.counterForView2==0)
        {
            UIViewController *newTopViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"Create Plans"];
            [self presentViewController:newTopViewController animated:YES completion:nil];
        }
        else    //detail view?
        {
            [self.slidingViewController anchorTopViewTo:ECLeft animations:NO onComplete:nil];
        }
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - preparations
-(void) setCollapseClick
{
    self.myCollapseClick.CollapseClickDelegate = self;
    [self.myCollapseClick reloadCollapseClick];
    
    // If you want a cell open on load, run this method:
    [self.myCollapseClick openCollapseClickCellAtIndex:0 animated:NO];
    
    /*
     // If you'd like multiple cells open on load, create an NSArray of NSNumbers
     // with each NSNumber corresponding to the index you'd like to open.
     // - This will open Cells at indexes 0,2 automatically
     
     NSArray *indexArray = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:2]];
     [myCollapseClick openCollapseClickCellsWithIndexes:indexArray animated:NO];
     */
}

-(void) Preparations
{
    //getdayofweek
    self.dayOfWeek.text = [TimeConverting getDayOfWeek:[NSDate date] andAbbreviation:NO];
    
    //shadow stuff
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 2.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    if (![self.slidingViewController.underRightViewController isKindOfClass:[ViewDayViewController class]]) {
        self.slidingViewController.underRightViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDay"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    NSLog(@"pan pan pan");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 2;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"Today";
            break;
        case 1:
            return @"Tomorrow";
            break;
            
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return self.test1View;
            break;
        case 1:
            return self.test2View;
            break;        
        default:
            return self.test1View;
            break;
    }
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor colorWithRed:131/255.0f green:131/255.0f blue:131/255.0f alpha:1.0];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithWhite:1.0 alpha:0.85];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
}

-(void)didClickCollapseClickCellAddBtnAtIndexByHao:(int)index
{
    UIViewController *newTopViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CP03Append"];
    [self presentViewController:newTopViewController animated:YES completion:nil];
    NSLog(@"dav");
}


#pragma mark - TextField Delegate for Demo
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (IBAction)LeftToggleBtn:(id)sender {
        [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)RightToggleBtn:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}



@end
