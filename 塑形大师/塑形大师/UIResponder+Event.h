//
//  UIResponder+Event.h
//  塑形大师
//
//  Created by yuqian on 2017/9/7.
//  Copyright © 2017年 com.tenyears. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Event)

/**
 *  发送一个消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName 发生的事件名称
 *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)passEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
