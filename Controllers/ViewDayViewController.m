//
//  ViewDayViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "ViewDayViewController.h"
#import "CRTableViewCell.h"
#import "OperationsWithDB.h"
#import "Event.h"
#import "TDBadgedCell.h"
#import "TimeConverting.h"
#import "ECSlidingViewController.h"
@interface ViewDayViewController ()
@property(nonatomic, assign) NSUInteger nbItems;
@property (nonatomic, assign) BOOL DeleteRowFlag;
@end

@implementation ViewDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) reloadAPlan:(NSNotification *)notification
{
    NSInteger value = [[notification.userInfo objectForKey:@"key"] intValue];
    NSLog(@"value:%i",value);
    
    if(value != -1)
    {
    
        contents = [OperationsWithDB fetchEventsByPid:value];
        self.nbItems = [contents count];
        [self.MSTableView reloadData];
        NSLog(@"reloaded suc");
    
        int createDate = [OperationsWithDB fetchCreateDateByPid:value];
    
        if([TimeConverting transfromNSDATEtoInt:[NSDate date]] == createDate)
        {
            self.navTopLabel.text = @"Today";
        }
        else
        {
            self.navTopLabel.text = [TimeConverting TimeDateINTToString:createDate];
        }
        
    }
    else    //equals -1, means coming back from menu
    {
        //need to check the current date in viewdaycontroller,if same, no need to change,else reload
        if(![self.navTopLabel.text isEqualToString:@"Today"])
        {
            //reload today's event
            self.slidingViewController.underRightViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDay"];
            NSLog(@"reinstantiate viewday controller**************************************");
        }
    }
    
    
    selectedMarks = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAPlan:) name:@"ReloadAPlan" object:nil];
    
    
    self.MSTableView.delegate=self;
    self.MSTableView.dataSource=self;
    
    self.navTopLabel.text = @"Today";
    
    //fetch today's plan
    contents = [OperationsWithDB fetchEvents:[NSDate date]];
    self.nbItems = [contents count];
    
    selectedMarks = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    return 150.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // init the CRTableViewCell
    if(self.nbItems==0)
    {
        static NSString *CellIdentifier = @"Cell";
        
        TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        [cell.textLabel setText:@"          No event"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        return cell;
    }
    else    //there are >0 Events
    {
        static NSString *CRTableViewCellIdentifier = @"cellIdentifier";
        CRTableViewCell *cell = (CRTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CRTableViewCellIdentifier];
    
        if (cell == nil) {
            cell = [[CRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CRTableViewCellIdentifier];
        }   
    

        // Check if the cell is currently selected (marked)
        Event *tmpE = [contents objectAtIndex:[indexPath row]];
        cell.isSelected = [selectedMarks containsObject:tmpE] ? YES : NO;
        
        cell.textLabel.text = ([tmpE.Category isEqualToString:@"(null)"])?@"":tmpE.Category;
        
        cell.detailLabeltop.text = tmpE.Ename;
        
        NSString *timeString=[TimeConverting TimeIntToString:tmpE.StartTime];
        cell.detailLabelbottom.text = timeString;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        return cell;
    }
    

}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.nbItems==0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    else
    {
        Event *tmpE = [contents objectAtIndex:[indexPath row]];
    
        if ([selectedMarks containsObject:tmpE])// Is selected?
            [selectedMarks removeObject:tmpE];
        else
            [selectedMarks addObject:tmpE];
    
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



- (IBAction)FinishEvents:(id)sender {
    NSLog(@"%@", selectedMarks);
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReloadAPlan" object:nil];
}
@end
