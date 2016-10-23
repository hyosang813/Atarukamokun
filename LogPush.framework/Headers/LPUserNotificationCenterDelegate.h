//
//  LPUserNotificationCenterDelegate.h
//  LogPush
//
//  Copyright © 2016 pLucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

// clang-format off
/**
 * UNUserNotificationCenterDelegate implentation for LogPush.
 */
@interface LPUserNotificationCenterDelegate : NSObject <UNUserNotificationCenterDelegate>
// clang-format on

/**
 * A shared instance.
 */
+ (LPUserNotificationCenterDelegate *)sharedInstance;
@end
