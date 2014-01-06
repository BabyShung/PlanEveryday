  
#import "TKCalendarMonthTableViewController.h"
#import "NSDate+TKCategory.h"


@implementation TKCalendarMonthTableViewController


- (void) loadView
{
	[super loadView];
	
	
	float y,height;
	y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	height = self.view.frame.size.height - y;
		
	
    //the table view beneath the grids
	 self.MyView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, height)];

    self.MyView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];
    
	[self.view addSubview:self.MyView];
	[self.view sendSubviewToBack:self.MyView];

    
        
    
    
    
}




#pragma mark Month View Delegate & Data Source
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d{
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated{
	[self updateTableOffset:animated];
}

- (void) updateTableOffset:(BOOL)animated{
	
	if(animated){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelay:0.1];
	}

	
	float y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	self.MyView.frame = CGRectMake(self.MyView.frame.origin.x, y, self.MyView.frame.size.width, self.view.frame.size.height - y );
	
    NSLog(@"test here--2 %f",y);
    
	if(animated) [UIView commitAnimations];
}







@end
