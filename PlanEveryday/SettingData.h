//
//  SettingData.h
//  PlanEveryday
//
//  Created by Hongye Wang on 5/12/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "OperationsWithDB.h"

@interface SettingData : NSObject{
    
    //NSInteger cindex;
}
@property (nonatomic) NSInteger pindex;
@property (nonatomic) NSInteger cindex;
- (NSString *) priorityForIndex;
- (UIColor *) colorForIndex;

@end