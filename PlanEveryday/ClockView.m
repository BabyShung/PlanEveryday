//
//  ClockView.m
//  AlarmClock
//
//  Created by Thorsten Schembs on 06.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClockView.h"

@interface ClockView() 
@property (nonatomic, retain, readwrite) NSCalendar *calendar;
@property (nonatomic, retain, readwrite) NSDate *time;
@property (nonatomic, retain) NSTimer *timer;
@end

@implementation ClockView

@synthesize calendar;
@synthesize time;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.calendar = [NSCalendar currentCalendar];
        self.time = [NSDate date];
    }
    return self;
}

 


- (void)startAnimation {
    if(self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) updateTime:(NSTimer*)inTimer {
    self.time = [NSDate date];
    [self setNeedsDisplay];
}


- (CGPoint)midPoint {
    CGRect theBounds = self.bounds;
    return CGPointMake(CGRectGetMidX(theBounds), CGRectGetMidY(theBounds));
}

- (CGPoint)pointWithRadius:(CGFloat)inRadius angle:(CGFloat)inAngle {
    CGPoint theCenter = [self midPoint];
    return CGPointMake(theCenter.x + inRadius * sin(inAngle), theCenter.y - inRadius * cos(inAngle));
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.calendar = [NSCalendar currentCalendar];
        self.time = [NSDate date];
        
    }
    return self;
}

- (void)drawClockHands {
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGPoint theCenter = [self midPoint];
    CGFloat theRadius = CGRectGetWidth(self.bounds) / 2.0;
    NSDateComponents *theComponents = [self.calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self.time];
    CGFloat theSecond = theComponents.second * M_PI / 30.0;
    CGFloat theMinute = theComponents.minute * M_PI / 30.0;
    CGFloat theHour = (theComponents.hour + theComponents.minute / 60) * M_PI / 6.0;

    CGPoint thePoint = [self pointWithRadius:theRadius * 0.55 angle:theHour];
    CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0);
    CGContextSetLineWidth(theContext, 7.0);
    CGContextSetLineCap(theContext, kCGLineCapButt);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);

    thePoint = [self pointWithRadius:theRadius * 0.67 angle:theMinute];
    CGContextSetLineWidth(theContext, 5.0);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);
    //length of the second pointer
    thePoint = [self pointWithRadius:theRadius * 0.82 angle:theSecond];
    CGContextSetRGBStrokeColor(theContext, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(theContext, 3.0);
    CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
    CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
    CGContextStrokePath(theContext);

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.calendar = [NSCalendar currentCalendar];
    self.time = [NSDate date];
}


- (void)drawRect:(CGRect)rect
{

    
    [self drawClockHands];
   
}

@end
