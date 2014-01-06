//
//  CP04ViewController.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/21/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTextViewPlaceholder.h"
#import "Thoughts.h"
@class CP04ViewController;
@protocol CP04Delegate <NSObject>

-(void)passInfoback:(CP04ViewController *)controller withThoughts:(Thoughts *)thought;
@end


@interface CP04ViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate>

@property (strong,nonatomic) Thoughts *CP04Thought;

@property (strong, nonatomic) IBOutlet UIScrollView *ThoughScrollView;

@property (strong, nonatomic) IBOutlet UITextField *Title;
@property (strong, nonatomic) IBOutlet CPTextViewPlaceholder *Content;
- (IBAction)DoneWithCP04View:(id)sender;

@property (strong,nonatomic) id<CP04Delegate> delegate;

@end
