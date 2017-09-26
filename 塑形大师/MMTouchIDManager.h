//
//  MMTouchIDManager.h
//  Easy4ip
//
//  Created by yuqian on 2017/9/11.
//  Copyright © 2017年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMTouchIDManager : NSObject

+ (MMTouchIDManager *)shareInstance;

- (void) checkTouchIDAuthority:(SucessfulBlock)success failed:(FailedBlockNoTip)failed;

@end
