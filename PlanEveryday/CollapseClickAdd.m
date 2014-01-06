//
//  CollapseClickAdd.m
//  PlanEveryday
//
//  Created by Hao Zheng on 7/2/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "CollapseClickAdd.h"

@implementation CollapseClickAdd

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.addBtnColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.addBtnColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    [self.addBtnColor setFill];
    [arrow moveToPoint:CGPointMake(0, self.frame.size.height/5*2)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*2, self.frame.size.height/5*2)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*2, 0)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*3, 0)];
    
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*3, self.frame.size.height/5*2)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/5*2)];
    
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/5*3)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*3, self.frame.size.height/5*3)];
    
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*3, self.frame.size.height)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*2, self.frame.size.height)];
    
    [arrow addLineToPoint:CGPointMake(self.frame.size.width/5*2, self.frame.size.height/5*3)];
    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height/5*3)];
    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height/5*2)];

    
    [arrow fill];
}
@end
