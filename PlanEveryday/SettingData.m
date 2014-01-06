//
//  SettingData.m
//  PlanEveryday
//
//  Created by Hongye Wang on 5/12/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "SettingData.h"

@implementation SettingData



- (NSString *) priorityForIndex{
    if (self.pindex == 0){
        return [NSString stringWithFormat:@"%s", "Trivia"];
    }else if (self.pindex == 1){
        return [NSString stringWithFormat:@"%s", "Normal"];
    }else{
        return [NSString stringWithFormat:@"%s", "Urgent"];
    }
}

- (UIColor *) colorForIndex{
    if (self.cindex == 0){
        return [UIColor lightGrayColor];
    }else if (self.cindex == 1){
        return [UIColor darkGrayColor];
    }else if (self.cindex ==2){
        return [UIColor blueColor];
    }else{
        return [UIColor greenColor];
    }
}


@end
