//
//  DCFineTuneSlider
//
//  Created by Patrick Richards on 27/05/11.
//  MIT License.
//
//  http://twitter.com/patr
//  http://domesticcat.com.au/projects
//  http://github.com/domesticcatsoftware/DCFineTuneSlider

#import "DCFineTuneSlider.h"

@interface DCFineTuneSlider()

- (void)setup;

@end

@implementation DCFineTuneSlider

@synthesize fineTuneAmount, increaseButton, decreaseButton, valueChangedHandler;

#pragma mark -


#pragma mark -
#pragma mark Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame decreaseButtonImage:(UIImage *)decreaseButtonImage increaseButtonImage:(UIImage *)increaseButtonImage fineTuneAmount:(CGFloat)aFineTuneAmount
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];

		self.fineTuneAmount = aFineTuneAmount;
		[self.decreaseButton setImage:decreaseButtonImage forState:UIControlStateNormal];
		[self.increaseButton setImage:increaseButtonImage forState:UIControlStateNormal];
	}

	return self;
}

- (void)setup
{
	// UISlider's default min is 0.0 and max is 1.0, 0.1 for fine tuning seems about right
	self.fineTuneAmount = 0.1;

	// create the fine tune buttons, their frames are setup in layoutSubviews
	self.decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self addSubview:self.decreaseButton];
	[self.decreaseButton addTarget:self action:@selector(fineTuneButtonPressed:) forControlEvents:UIControlEventTouchDown];

	self.increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.increaseButton addTarget:self action:@selector(fineTuneButtonPressed:) forControlEvents:UIControlEventTouchDown];
	[self addSubview:self.increaseButton];

	// add the double tap to jump recognizer
	UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
	doubleTapGestureRecognizer.numberOfTapsRequired = 2;
	doubleTapGestureRecognizer.cancelsTouchesInView = NO;
	doubleTapGestureRecognizer.delaysTouchesEnded = NO;
	[self addGestureRecognizer:doubleTapGestureRecognizer];
}

#pragma mark -
#pragma mark Layout

- (CGRect)trackRectForBounds:(CGRect)bounds
{
	// return a shortened track rect to account for the fine tune buttons
    CGRect result = [super trackRectForBounds:bounds];
    return CGRectInset(result, self.frame.size.height+20, 0.0);
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGFloat buttonSize = self.frame.size.height;
	self.decreaseButton.frame = CGRectMake(0, 0, buttonSize*2, buttonSize);
	self.increaseButton.frame = CGRectMake(self.frame.size.width - buttonSize*2, 0, buttonSize*2, buttonSize);
}

#pragma mark -
#pragma mark Fine Tune Buttons

- (void)fineTuneButtonPressed:(id)sender
{
	if (sender == self.increaseButton)
    {
        if(self.value>=720)
        {
            self.value-=720;
            [self setValue:self.value + self.fineTuneAmount animated:YES];
        }
        else
        {
            [self setValue:self.value + self.fineTuneAmount animated:YES];
        }
        NSLog(@"self.value:%f",self.value);
        NSLog(@"fineTuneAmount:%f",self.fineTuneAmount);
        
    }
	else if (sender == self.decreaseButton)
    {
        if(self.value<=0)
        {
            self.value+=720;
            [self setValue:self.value - self.fineTuneAmount animated:YES];
        }
        else
        {
            [self setValue:self.value - self.fineTuneAmount animated:YES];
        }
		NSLog(@"self.value:%f",self.value);
        NSLog(@"fineTuneAmount:%f",self.fineTuneAmount);
    }

	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark Touch Handling

- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint tapPoint = [gestureRecognizer locationInView:self];
	CGRect trackRect = [self trackRectForBounds:self.bounds];
	CGRect thumbRect = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];

	// check if it's on the thumb
	if (CGRectContainsPoint(thumbRect, tapPoint))
		return;

	// check if it's outside the track (with some leeway in the y direction)
	if (!CGRectContainsPoint(CGRectInset(trackRect, 0.0, -5.0), tapPoint))
		return;

	// calculate and set the new value
	CGFloat range = (self.maximumValue - self.minimumValue);
	CGFloat newValue = range * (tapPoint.x - CGRectGetMinX(trackRect)) / CGRectGetWidth(trackRect);
	[self setValue:newValue animated:YES];

	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark Block Support

- (void)setValue:(float)value
{
	[super setValue:value];

	// pass the value to the block if defined
	if (self.valueChangedHandler)
		self.valueChangedHandler(self);
}

- (void)setValue:(float)value animated:(BOOL)animated
{
	[super setValue:value animated:animated];

	// pass the value to the block if defined
	if (self.valueChangedHandler)
		self.valueChangedHandler(self);
}

@end
