//
//  ECSlidingViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageWithUIView.h"

/** Notification that gets posted when the underRight view will appear */
extern NSString *const ECSlidingViewUnderRightWillAppear;

/** Notification that gets posted when the underLeft view will appear */
extern NSString *const ECSlidingViewUnderLeftWillAppear;

/** Notification that gets posted when the underLeft view will disappear */
extern NSString *const ECSlidingViewUnderLeftWillDisappear;

/** Notification that gets posted when the underRight view will disappear */
extern NSString *const ECSlidingViewUnderRightWillDisappear;

/** Notification that gets posted when the top view is anchored to the left side of the screen */
extern NSString *const ECSlidingViewTopDidAnchorLeft;

/** Notification that gets posted when the top view is anchored to the right side of the screen */
extern NSString *const ECSlidingViewTopDidAnchorRight;

/** Notification that gets posted when the top view will be centered on the screen */
extern NSString *const ECSlidingViewTopWillReset;

/** Notification that gets posted when the top view is centered on the screen */
extern NSString *const ECSlidingViewTopDidReset;


typedef enum {
    /** Under view will take up the full width of the screen */
    ECFullWidth,
    /** Under view will have a fixed width equal to anchorRightRevealAmount or anchorLeftRevealAmount. */
    ECFixedRevealWidth,
    /** Under view will have a variable width depending on rotation equal to the screen's width - anchorRightPeekAmount or anchorLeftPeekAmount. */
    ECVariableRevealWidth
} ECViewWidthLayout;

typedef enum {
    /** Left side of screen */
    ECLeft,
    /** Right side of screen */
    ECRight
} ECSide;

typedef enum {
    /** No reset strategy will be used */
    ECNone = 0,
    /** Tapping the top view will reset it */
    ECTapping = 1 << 0,
    /** Panning will be enabled on the top view. If it is panned and released towards the reset position it will reset, otherwise it will slide towards the anchored position. */
    ECPanning = 1 << 1
} ECResetStrategy;


@interface ECSlidingViewController : UIViewController{
    CGPoint startTouchPosition;
    BOOL topViewHasFocus;
}

//menu
@property (nonatomic, strong) UIViewController *underLeftViewController;

//view day
@property (nonatomic, strong) UIViewController *underRightViewController;

//top
@property (nonatomic, strong) UIViewController *topViewController;

//rotation
@property (nonatomic, unsafe_unretained) CGFloat anchorLeftPeekAmount;
@property (nonatomic, unsafe_unretained) CGFloat anchorRightPeekAmount;
@property (nonatomic, unsafe_unretained) CGFloat anchorLeftRevealAmount;
@property (nonatomic, unsafe_unretained) CGFloat anchorRightRevealAmount;

/** Specifies if the user should be able to interact with the top view when it is anchored.
 
 By default, this is set to NO
 */
@property (nonatomic, unsafe_unretained) BOOL shouldAllowUserInteractionsWhenAnchored;

/** Specifies if the top view snapshot requires a pan gesture recognizer.
 
 This is useful when panGesture is added to the navigation bar instead of the main view.
 
 By default, this is set to NO
 */
@property (nonatomic, unsafe_unretained) BOOL shouldAddPanGestureRecognizerToTopViewSnapshot;

// Specifies the behavior for the under left width.By default, this is set to ECFullWidth
@property (nonatomic, unsafe_unretained) ECViewWidthLayout underLeftWidthLayout;
//Specifies the behavior for the under right width.By default, this is set to ECFullWidth
@property (nonatomic, unsafe_unretained) ECViewWidthLayout underRightWidthLayout;

/** Returns the strategy for resetting the top view when it is anchored.
 By default, this is set to ECPanning | ECTapping to allow both panning and tapping to reset the top view.
 If this is set to ECNone, then there must be a custom way to reset the top view otherwise it will stay anchored.
 */
@property (nonatomic, unsafe_unretained) ECResetStrategy resetStrategy;



- (UIPanGestureRecognizer *)panGesture;

//slide + side(direction)
- (void)anchorTopViewTo:(ECSide)side;
//sub method
- (void)anchorTopViewTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

//Slides the top view off of the screen in the direction of the specified side.
- (void)anchorTopViewOffScreenTo:(ECSide)side;
- (void)anchorTopViewOffScreenTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

//top view back to the center.
- (void)resetTopView;
- (void)resetTopViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete;

/** Returns true if the underLeft view is showing (even partially) */
- (BOOL)underLeftShowing;
- (BOOL)underRightShowing;
/** Returns true if the top view is completely off the screen */
- (BOOL)topViewIsOffScreen;

@end

/** UIViewController extension */
@interface UIViewController(SlidingViewExtension)
//a reference
- (ECSlidingViewController *)slidingViewController;
@end