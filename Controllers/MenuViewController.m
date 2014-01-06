//
//  MenuViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"


@interface MenuViewController ()

@end

@implementation MenuViewController

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
	self.PESearchBar.delegate = self;
    //self.PESearchBar.tintColor = [UIColor blueColor];
    //self.PETableView.backgroundColor = [UIColor blueColor];
    
    self.PETableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tileCircle.png"]];
    
    
    //nsNotification    refresh and reset topview
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTopV) name:@"MainNC" object:nil];
    //nsNotification2   refresh without reset
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMain) name:@"refreshMainView" object:nil];
    
    
    self.PETableView.delegate=self;
    self.PETableView.dataSource=self;
    self.section1 = [NSArray arrayWithObjects:@"Main View", @"Calendar", @"My Plans",@"My Thoughts", nil];
    self.section2 = [NSArray arrayWithObjects:@"Create Plans",@"Alarm Clock", @"Settings", nil];
    self.menu = [NSArray arrayWithObjects:self.section1, self.section2, nil];
    
    //how much to show
    [self.slidingViewController setAnchorRightRevealAmount:260.0f];
    [self.slidingViewController setAnchorLeftRevealAmount:260.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

-(void)resetTopV    //call by notificationceter, refresh and reset topview
{
    //this works,it will refresh the table
    UIViewController *tv = [self.storyboard instantiateViewControllerWithIdentifier:@"Main View"];
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = tv;
    self.slidingViewController.topViewController.view.frame = frame;
    
    //refresh viewday
    UIViewController *tv2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewDay"];
    [self changeViewsInUnderLeftWithOutReset:tv2];
    
    //delay code
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if((int)frame.origin.x==260)
        {
            [self.slidingViewController resetTopView];
        }
    });

}
-(void)refreshMain    //call by notificationceter, refresh without reset
{
    //this works,it will refresh the table
    UIViewController *tv = [self.storyboard instantiateViewControllerWithIdentifier:@"Main View"];

    [self changeViewsInMainViewWithOutReset:tv];

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"MainNC" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshMainView" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return [self.section1 count];
        
    } else if (section == 1) {
        
        return [self.section2 count];
    }
    else    //need modification
        return 0;
}


//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    
//    if (section == 0) {
//        
//        return @"Views";
//        
//    } else if (section == 1) {
//        
//        return @"Actions";
//    }
//    else    //need modification
//        return 0;
//    
//    
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {   //section 1
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.section1 objectAtIndex:indexPath.row]];
        
        if(indexPath.row == 0)
        {
            cell.imageView.image = [UIImage imageNamed:@"MainViewPage.png"];
        }
        else if(indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"CalendarPage.png"];
        }
        else if(indexPath.row == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"MyPlanPage.png"];
        }
        else if(indexPath.row == 3)
        {
            cell.imageView.image = [UIImage imageNamed:@"MenuDiary.png"];
        }
 
        
        
    } else if (indexPath.section == 1) {    //section 2
              
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.section2 objectAtIndex:indexPath.row]];
        
        if(indexPath.row == 0)
        {
            cell.imageView.image = [UIImage imageNamed:@"editICON.png"];
        }
        else if(indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"MenuClock"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"MSetting"];
        }
    }
    
    //cell.backgroundColor = [UIColor darkGrayColor];
//    : [UIColor blackColor];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.detailTextLabel.backgroundColor = [UIColor clearColor];

    
    
    return cell;
}


#pragma mark - Table view delegate
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *newTopViewController;
    
    if (indexPath.section == 0)
    {
        
        NSString *identifier = [NSString stringWithFormat:@"%@", [self.section1 objectAtIndex:indexPath.row]];
        
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        if(indexPath.row == 0 )  //if 'Main' is clicked
        {
            if([self.CurrentTopViewName isEqualToString:@"Main View"])
            {
                [self.slidingViewController resetTopView];
            
            }
            else
            {
                [self changeViewsInMainView:newTopViewController];
            }
            
        }
        else    //change in main view
        {
            [self changeViewsInMainView:newTopViewController];
        }
        self.CurrentTopViewName = identifier;
        
        
    }
    else if (indexPath.section == 1)
    {
        
        NSString *identifier = [NSString stringWithFormat:@"%@", [self.section2 objectAtIndex:indexPath.row]];
        
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
 
        //click create plan or alarm clock
        [self changeViewsByPresentingNewViews:newTopViewController];
            
 
        self.CurrentTopViewName = identifier;
    } 
    
    //deselect the lines background
    [self.PETableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void) changeViewsInMainView:(UIViewController *)tmpView {
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = tmpView;
        self.slidingViewController.topViewController.view.frame = frame;
        if((int)frame.origin.x==260)
        {
            [self.slidingViewController resetTopView];
        }
        NSLog(@"refresh top view");
}
-(void) changeViewsInMainViewWithOutReset:(UIViewController *)tmpView {
    
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    
    self.slidingViewController.topViewController = tmpView;
    
  //  [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.slidingViewController.topViewController.view.frame = frame;


    NSLog(@"refresh top view without resetting");
}

-(void) changeViewsInUnderLeftWithOutReset:(UIViewController *)tmpView {
    CGRect frame = self.slidingViewController.underRightViewController.view.frame;
    self.slidingViewController.underRightViewController = tmpView;
    self.slidingViewController.underRightViewController.view.frame = frame;
    NSLog(@"refresh underright view without resetting");
}

-(void) changeViewsByPresentingNewViews:(UIViewController *)tmpView {
    [self presentViewController:tmpView animated:YES completion:nil];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.PESearchBar resignFirstResponder];
    //[self.slidingViewController resetTopView];
    [self.slidingViewController anchorTopViewTo:ECRight animations:nil onComplete:nil];

}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    NSLog(@"yeah");
//    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:nil];
//    return YES;
    return NO;
}

@end
