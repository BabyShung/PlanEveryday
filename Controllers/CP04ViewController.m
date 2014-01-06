//
//  CP04ViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/21/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "CP04ViewController.h"

//return msg
#import "SVProgressHUD.h"
//alertview
#import "UIAlertView+Blocks.h"

@interface CP04ViewController ()

@end

@implementation CP04ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.ThoughScrollView setScrollEnabled:YES];
    
    //set delegates
    self.Content.delegate=self;
    self.Title.delegate=self;
    //  let textfield has glowing

    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MySingleTap:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    if (self.CP04Thought.Content.length==0)
    {
        self.Content.placeholder = @"How are you?";
        
        self.Title.text=self.CP04Thought.Title;
    }
    else
    {
        self.Title.text=self.CP04Thought.Title;
        self.Content.text=self.CP04Thought.Content;
    }
}

- (void)MySingleTap:(UITapGestureRecognizer *)sender
{
    [self.Title resignFirstResponder];
    [self.Content resignFirstResponder];
    [self.ThoughScrollView setContentOffset:CGPointMake(0,0)
                                   animated:YES];
}

//delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.ThoughScrollView setContentOffset:CGPointMake(0,self.Content.frame.origin.y-10)
                             animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.ThoughScrollView setContentOffset:CGPointMake(0,self.Title.frame.origin.y-10)
                                   animated:YES];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(self.Content.text.length==0)
    {
        self.Content.placeholder = @"How are you?";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.ThoughScrollView setContentOffset:CGPointMake(0,0)
                                   animated:YES];
    return YES;
}

- (IBAction)BackBTN:(id)sender {
    
    if(self.Title.text.length!=0||![self.Content.text isEqualToString: @"How are you?"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait a second"
                                                        message:@"Discard this thought?"
                                                       delegate:nil
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        
        [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex != [alertView cancelButtonIndex]) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    else
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoneWithCP04View:(id)sender {
  
    if(!self.CP04Thought)
    {
        self.CP04Thought = [[Thoughts alloc]init];
    }
    
    
    if(self.Title.text.length==0)
    {
        [UIAlertView showWarningWithMessage:@"Please enter something."
                                    handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        
                                        NSLog(@"Warning dismissed");
                                    }];
    }
    else
    {
        self.CP04Thought.Title=self.Title.text;
        self.CP04Thought.Content=self.Content.text;

        [SVProgressHUD showSuccessWithStatus:@"Thought modified!"];

        [self.delegate passInfoback:self withThoughts:self.CP04Thought];
        
        //delay code
        double delayInSeconds = 0.4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        });

    }
    

}
@end
