//
//  UICircularSlider.m
//  UICircularSlider
//
//  Created by Zouhair Mahieddine on 02/03/12.
//  Copyright (c) 2012 Zouhair Mahieddine.
//  http://www.zedenem.com
//  
//  This file is part of the UICircularSlider Library, released under the MIT License.
//

#import "UICircularSlider.h"

@interface UICircularSlider()


@property (nonatomic) CGPoint thumbCenterPoint;

#pragma mark - Init and Setup methods
- (void)setup;

#pragma mark - Thumb management methods
- (BOOL)isPointInThumb:(CGPoint)point;

#pragma mark - Drawing methods
- (CGFloat)sliderRadius;
- (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint inContext:(CGContextRef)context;
- (CGPoint)drawCircularTrack:(float)track atPoint:(CGPoint)point withRadius:(CGFloat)radius inContext:(CGContextRef)context;
- (CGPoint)drawPieTrack:(float)track atPoint:(CGPoint)point withRadius:(CGFloat)radius inContext:(CGContextRef)context;

@end

#pragma mark -
@implementation UICircularSlider

@synthesize value = _value;
- (void)setValue:(float)value {
	if (value != _value) {
		if (value > self.maximumValue) { value = self.maximumValue; }
		if (value < self.minimumValue) { value = self.minimumValue; }
		_value = value;
		[self setNeedsDisplay];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}
@synthesize minimumValue = _minimumValue;
- (void)setMinimumValue:(float)minimumValue {
	if (minimumValue != _minimumValue) {
		_minimumValue = minimumValue;
		if (self.maximumValue < self.minimumValue)	{ self.maximumValue = self.minimumValue; }
		if (self.value < self.minimumValue)			{ self.value = self.minimumValue; }
	}
}
@synthesize maximumValue = _maximumValue;
- (void)setMaximumValue:(float)maximumValue {
	if (maximumValue != _maximumValue) {
		_maximumValue = maximumValue;
		if (self.minimumValue > self.maximumValue)	{ self.minimumValue = self.maximumValue; }
		if (self.value > self.maximumValue)			{ self.value = self.maximumValue; }
	}
}

@synthesize minimumTrackTintColor = _minimumTrackTintColor;
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
	if (![minimumTrackTintColor isEqual:_minimumTrackTintColor]) {
		_minimumTrackTintColor = minimumTrackTintColor;
		[self setNeedsDisplay];
	}
}

@synthesize maximumTrackTintColor = _maximumTrackTintColor;
- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
	if (![maximumTrackTintColor isEqual:_maximumTrackTintColor]) {
		_maximumTrackTintColor = maximumTrackTintColor;
		[self setNeedsDisplay];
	}
}

@synthesize thumbTintColor = _thumbTintColor;
- (void)setThumbTintColor:(UIColor *)thumbTintColor {
	if (![thumbTintColor isEqual:_thumbTintColor]) {
		_thumbTintColor = thumbTintColor;
		[self setNeedsDisplay];
	}
}

@synthesize continuous = _continuous;

@synthesize sliderStyle = _sliderStyle;
- (void)setSliderStyle:(UICircularSliderStyle)sliderStyle {
	if (sliderStyle != _sliderStyle) {
		_sliderStyle = sliderStyle;
		[self setNeedsDisplay];
	}
}

@synthesize thumbCenterPoint = _thumbCenterPoint;

/** @name Init and Setup methods */
#pragma mark - Init and Setup methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    } 
    return self;
}
- (void)awakeFromNib {
	[self setup];
}

- (void)setup {
	self.value = 0.0;
	self.minimumValue = 0.0;
	self.maximumValue = 1.0;
    //circle color
	self.minimumTrackTintColor = [UIColor colorWithRed:198/255.0f green:0/255.0f blue:6/255.0f alpha:1.0];
	self.maximumTrackTintColor = [UIColor grayColor];
	self.thumbTintColor = [UIColor darkGrayColor];
	self.continuous = YES;
	self.thumbCenterPoint = CGPointZero;
	
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHappened:)];
	[self addGestureRecognizer:tapGestureRecognizer];
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
	panGestureRecognizer.maximumNumberOfTouches = panGestureRecognizer.minimumNumberOfTouches;
	[self addGestureRecognizer:panGestureRecognizer];
}

/** @name Drawing methods */
#pragma mark - Drawing methods
#define kLineWidth 14.0
#define kThumbRadius 16.0

- (CGFloat)sliderRadius
{
//    NSLog(@"w %f",self.bounds.size.width);
//    NSLog(@"h %f",self.bounds.size.height);
//    NSLog(@"%f",self.frame.size.width);
	CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
	radius -= MAX(kLineWidth, kThumbRadius);
	return radius;
}

- (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y);
	CGContextAddArc(context, sliderButtonCenterPoint.x, sliderButtonCenterPoint.y, kThumbRadius, 0.0, 2*M_PI, NO);
	
	CGContextFillPath(context);
	UIGraphicsPopContext();
}

//----------------
- (CGPoint)drawCircularTrack:(float)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
	UIGraphicsPushContext(context);
	CGContextBeginPath(context);
	
	float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
	
	CGFloat startAngle = -M_PI_2;
	CGFloat endAngle = startAngle + angleFromTrack;
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextStrokePath(context);
	UIGraphicsPopContext();
//	NSLog(@"closerrrrrrr------%f",-M_PI_2);
	return arcEndPoint;
}

- (CGPoint)drawPieTrack:(float)track atPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context {
	UIGraphicsPushContext(context);
	
	float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
	
	CGFloat startAngle = -M_PI_2;
	CGFloat endAngle = startAngle + angleFromTrack;
	CGContextMoveToPoint(context, center.x, center.y);
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
	UIGraphicsPopContext();
	
	return arcEndPoint;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGPoint middlePoint;
	middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
	middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2;
//    NSLog(@"mx %f",middlePoint.x);
//    NSLog(@"my %f",middlePoint.y);
	CGContextSetLineWidth(context, kLineWidth);
	
	CGFloat radius = [self sliderRadius];
    //NSLog(@"radius %f",radius);
	switch (self.sliderStyle) {
            
		case UICircularSliderStylePie:
			[self.maximumTrackTintColor setFill];
			[self drawPieTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
			[self.minimumTrackTintColor setStroke];
			[self drawCircularTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
			[self.minimumTrackTintColor setFill];
			self.thumbCenterPoint = [self drawPieTrack:self.value atPoint:middlePoint withRadius:radius inContext:context];
			break;
            
            
            //actually run this one!!!!!!!
		case UICircularSliderStyleCircle:
		default:
			[self.maximumTrackTintColor setStroke];
			[self drawCircularTrack:self.maximumValue atPoint:middlePoint withRadius:radius inContext:context];
			[self.minimumTrackTintColor setStroke];
			self.thumbCenterPoint = [self drawCircularTrack:self.value atPoint:middlePoint withRadius:radius inContext:context];
           // NSLog(@"-------thumbcP X %f",self.thumbCenterPoint.x);
           // NSLog(@"-------thumbcP Y %f",self.thumbCenterPoint.y);
			break;
	}
	
	[self.thumbTintColor setFill];
	[self drawThumbAtPoint:self.thumbCenterPoint inContext:context];
    
    
    //hao defined
//    BOOL a = [self isPointInThumb:self.thumbCenterPoint];
//    CGPoint tmpCG = CGPointMake(20, 30);
//    BOOL b = [self isPointInThumb:tmpCG];
//    NSLog(@"-------thumbcP X %i",a);
//    NSLog(@"-------thumbcP Y %i",b);


}

/** @name Thumb management methods */
#pragma mark - Thumb management methods
- (BOOL)isPointInThumb:(CGPoint)point {
	CGRect thumbTouchRect = CGRectMake(self.thumbCenterPoint.x - kThumbRadius, self.thumbCenterPoint.y - kThumbRadius, kThumbRadius*2, kThumbRadius*2);
	return CGRectContainsPoint(thumbTouchRect, point);
}

/** @name UIGestureRecognizer management methods */
#pragma mark - UIGestureRecognizer management methods
- (void)panGestureHappened:(UIPanGestureRecognizer *)panGestureRecognizer {
	CGPoint tapLocation = [panGestureRecognizer locationInView:self];
	switch (panGestureRecognizer.state) {
		case UIGestureRecognizerStateChanged: {
			CGFloat radius = [self sliderRadius];
			CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
			CGPoint sliderStartPoint = CGPointMake(sliderCenter.x, sliderCenter.y - radius);
			CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
			
			if (angle < 0) {
				angle = -angle;
			}
			else {
				angle = 2*M_PI - angle;
			}
			
			self.value = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
			break;
		}
		default:
			break;
	}
}
- (void)tapGestureHappened:(UITapGestureRecognizer *)tapGestureRecognizer {
	if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
		CGPoint tapLocation = [tapGestureRecognizer locationInView:self];
		if ([self isPointInThumb:tapLocation]) {
		}
		else {
		}
	}
}

@end

/** @name Utility Functions */
#pragma mark - Utility Functions
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum) {
	float a, b, destinationValue;
	
	a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
	b = destinationIntervalMaximum - a*sourceIntervalMaximum;
	
	destinationValue = a*sourceValue + b;
	
	return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) {
	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
	
	return angle;
}
