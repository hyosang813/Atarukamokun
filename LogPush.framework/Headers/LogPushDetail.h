//
//  LogPushDetail.h
//  LogPush
//
//  Copyright (c) 2015 pLucky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LPEnv.h"

@interface LogPushDetail : NSObject

/**
 * Setup LogPush.
 *
 * It is automatically invoked when using
 * `startWithApplicationId:withSecretKey:withEnv:`.
 *
 * @param applicationId Application ID.
 * @param secretKey Secret key.
 * @param env Specify LP_ENV if you use DEBUG macro in default way. Otherwise
 * specify LPDevelopment or LPProduction.
 */
+ (void)setApplicationId:(nonnull NSString *)applicationId
           withSecretKey:(nonnull NSString *)secretKey
                 withEnv:(LPEnv)env
    __attribute__((deprecated(
        "Use [LogPush initApplicationId:secretKey:launchOptions:] instead")));

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
+ (void)requestDeviceToken
    __attribute__((deprecated("Use [LogPush requestDeviceToken] instead")));

/**
 * Register device token with LogPush.
 *
 * It is automatically invoked when using
 * `startWithApplicationId:withSecretKey:withEnv:`.
 */
+ (void)registerDeviceToken:(nonnull NSData *)token
                    withEnv:(LPEnv)env
    __attribute__((deprecated(
        "Use [LogPush "
        "application:didRegisterForRemoteNotificationsWithDeviceToken"
        ":withEnv:] instead")));

/**
 * Set pre-defined tags which contains information of this device.
 *
 * It is automatically invoked when using
 * `startWithApplicationId:withSecretKey:withEnv:`.
 */
+ (void)setDeviceTags
    __attribute__((deprecated("Use [LogPush setDeviceTags] instead")));

/**
 * Invoke from application:didReceiveRemoteNotification:.
 *
 * It is automatically invoked when using
 * `startWithApplicationId:withSecretKey:withEnv:`.
 */
+ (void)didOpenRemoteNotification:(nonnull NSDictionary *)userInfo;

/**
 * Set base URL of API server.
 * Testing purpose only.
 */
+ (void)setBaseUrl:(nonnull NSURL *)baseUrl;
@end
