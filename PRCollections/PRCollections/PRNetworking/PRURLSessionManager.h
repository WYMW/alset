//
//  PRURLSessionManager.h
//  PRCollections
//
//  Created by YmWw on 2020/5/1.
//  Copyright © 2020 com.caogenleague.monster. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 `PRURLSessionManager` creates and manages an `NSURLSession` object based on specified `NSURLSessionConfiguration` object, which conforms
 to `<NSURLSessionTaskDelegate>`, `<NSURLSessionDataDelegate>`, `<NSURLSessionDownloadDelegate>`, and `<NSURLSessionDelegate>`.
 */

@interface PRURLSessionManager : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionDelegate>

@property (readonly, nonatomic, strong) NSURLSession *session;

/**
 The operation queue on which delegate callbacks are run.
 */
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

/**
 The data, upload, download tasks currently run by the managed session
 */
@property (readonly, nonatomic, strong) NSArray<NSURLSessionTask *> *tasks;
@property (readonly, nonatomic, strong) NSArray<NSURLSessionDataTask *> *dataTasks;
@property (readonly, nonatomic, strong) NSArray<NSURLSessionUploadTask *> *uploadTasks;
@property (readonly, nonatomic, strong) NSArray<NSURLSessionDownloadTask *> *downloadTasks;
@property (readonly, nonatomic, strong) NSMutableDictionary *taskDelegateKeyedByTaskIdentifier;

//The dispatch queue for `completeBlock`. If `NULL` (default), the main queue is used.
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;

//The dispatch queue for `completeBlock`. If `NULL` (default), a private dispatch group is used.
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;


/**
 Creates and returns a manager for a session created with the specified configuration. This is the designated initializer.
 @param configuration The configuration used to create the managed session.
 @return A manager for a newly-created session.
 */
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
