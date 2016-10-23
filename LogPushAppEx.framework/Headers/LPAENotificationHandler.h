//
//  LPAENotificationHandler.h
//  LogPush
//
//  Copyright © 2016 pLucky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface LPAENotificationHandler : NSObject

/**
 * Handle mutable notification content.
 *
 * This method reads LogPush specific information from content and mutate
 * content.
 * contentHandler will be invoked after content mutation.
 *
 * @param content Notification content to be mutated.
 * @param contentHandler Content handler.
 */
+ (void)handleContent:(nullable UNMutableNotificationContent *)content
    withContentHandler:
        (void (^_Nonnull)(UNNotificationContent *_Nonnull))contentHandler;
@end
