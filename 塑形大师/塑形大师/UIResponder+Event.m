//
//  UIResponder+Event.m
//  塑形大师
//
//  Created by yuqian on 2017/9/7.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import "UIResponder+Event.h"

@implementation UIResponder (Event)

- (void)passEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] passEventWithName:eventName userInfo:userInfo];
}

@end
