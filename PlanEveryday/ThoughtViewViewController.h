//
//  Created by Matt Greenfield on 24/05/12
//  Copyright (c) 2012 Big Paua. All rights reserved
//  http://bigpaua.com/
//

#import <UIKit/UIKit.h>
#import "CP04ViewController.h"
 

@interface ThoughtViewViewController : UIViewController <UIScrollViewDelegate,CP04Delegate>

 
@property (strong, nonatomic) IBOutlet UIView *displayView;


- (IBAction)LeftToggleBtn:(id)sender;
- (IBAction)RightToggleBtn:(id)sender;

@end
