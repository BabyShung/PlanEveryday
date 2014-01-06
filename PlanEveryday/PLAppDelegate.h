//
//  PLAppDelegate.h
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>



#import <AVFoundation/AVAudioPlayer.h>
@interface PLAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    SystemSoundID notifSound;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AVAudioPlayer *player;
@end
