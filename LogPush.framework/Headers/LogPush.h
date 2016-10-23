//
//  LogPush.h
//  LogPush
//
//  Copyright (c) 2015 pLucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for LogPush.
FOUNDATION_EXPORT double LogPushVersionNumber;

//! Project version string for LogPush.
FOUNDATION_EXPORT const unsigned char LogPushVersionString[];

#import "LPEnv.h"
#import "LPLimit.h"
#import "LPLogLevel.h"
#import "LPUserNotificationCenterDelegate.h"
#import "LogPushDetail.h"

typedef NS_OPTIONS(NSUInteger, LPStartFlag) {
  LPStartNoFlag = 0,
  LPStartDisableDeviceTokenRequest = 1 << 0,
};

/**
 * LogPush public interface.
 */
@interface LogPush : NSObject

/**
 * Setup LogPush and automate device token handling etc.
 *
 * Automate set up contains followings:
 * - requests device token
 * - sends received device token to LogPush server
 * - sets device tags
 * - sets `latest_launch_time` tag
 * - tracks open of remote notification from LogPush
 *
 * This method replaces UIApplication's delegate with LPApplicationDelegate,
 * which proxy message to original one.
 *
 * After a successful invocation, subsequent invocations are ignored.
 *
 * @param applicationId Application ID.
 * @param secretKey Secret key.
 * @param env Specify LP_ENV if you use DEBUG macro in default way. Otherwise
 * specify LPDevelopment or LPProduction.
 */
+ (void)startWithApplicationId:(nonnull NSString *)applicationId
                 withSecretKey:(nonnull NSString *)secretKey
                       withEnv:(LPEnv)env
    __attribute__((deprecated("See SDK documentation for detail.")));

+ (void)startWithApplicationId:(nonnull NSString *)applicationId
                 withSecretKey:(nonnull NSString *)secretKey
                       withEnv:(LPEnv)env
                         flags:(LPStartFlag)flags
    __attribute__((deprecated("See SDK documentation for detail.")));

+ (void)initApplicationId:(nonnull NSString *)applicationId
                secretKey:(nonnull NSString *)secretKey
            launchOptions:(nullable NSDictionary *)launchOptions;

/**
 * Set a handler to be called when a notification is opened.
 * Custom field and extra values (which is used by LogPush and APNs) are
 * included in a handler parameter.
 *
 * @param handler Handler.
 */
+ (void)setOpenHandler:(nonnull void (^)(NSDictionary *_Nullable))handler;

/**
 * Set pre-defined tags which contains information of this device.
 *
 * It is automatically invoked when using
 * `startWithApplicationId:withSecretKey:withEnv:`.
 */
+ (void)setDeviceTags;

/**
 * Request device token.
 *
 * It calls `registerForRemoteNotificationTypes:` on before iOS 8.0,
 * `registerForRemoteNotifications` and `registerUserNotificationSettings:` on
 * iOS 8.0 and later.
 *
 * It is automatically invoked when using
 * `startWithApplicationId:withSecretKey:withEnv:`.
 */
+ (void)requestDeviceToken;

+ (void)application:(nullable UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)token
                                             withEnv:(LPEnv)env;

+ (void)application:(nullable UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(nullable NSError *)error;

+ (void)application:(nullable UIApplication *)application
    didReceiveRemoteNotification:(nullable NSDictionary *)userInfo
          fetchCompletionHandler:
              (nonnull void (^)(UIBackgroundFetchResult result))
                  completionHandler;

+ (void)setLogLevel:(LPLogLevel)level;

/**
 * Set a tag with a given value.
 *
 * @param tag Tag. Allowed characters are [a-zA-Z0-9_].
 * @param value Tag value.
 */
+ (void)setTag:(nonnull NSString *)tag withValue:(nullable NSString *)value;

/**
 * Set a tag with an empty string.
 *
 * @param tag Tag.
 */
+ (void)setTag:(nonnull NSString *)tag;

/**
 * Set a tag with a given int.
 *
 * @param tag Tag.
 * @param value Integer tag value.
 */
+ (void)setTag:(nonnull NSString *)tag withInt:(NSInteger)value;

/**
 * Set a tag with a given double.
 *
 * @param tag Tag.
 * @param value Double tag value.
 */
+ (void)setTag:(nonnull NSString *)tag withDouble:(double)value;

/**
 * Set a tag with a given date.
 *
 * @param tag Tag.
 * @param value Date tag value.
 */
+ (void)setTag:(nonnull NSString *)tag withDate:(nonnull NSDate *)value;

/**
 * Set a tag with current time.
 *
 * @param tag Tag.
 */
+ (void)setTagWithCurrentTime:(nonnull NSString *)tag;

/**
 * Delete a tag.
 *
 * @param tag Tag.
 */
+ (void)deleteTag:(nonnull NSString *)tag;

/**
 * Format a device token to a string.
 * A returned string can be used as a parameter of LogPush API.
 *
 * @param token Device token to format.
 */
+ (nonnull NSString *)formatDeviceToken:(nonnull NSData *)token;

@end
