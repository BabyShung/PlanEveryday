  
#import "TKCalendarMonthTableViewController.h"
#import "NSDate+TKCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation TKCalendarMonthTableViewController


- (void) loadView
{
	[super loadView];
	
	
	    
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

    
    
	if(animated) [UIView commitAnimations];
}







@end
