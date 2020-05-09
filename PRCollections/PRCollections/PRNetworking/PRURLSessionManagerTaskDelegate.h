//
//  PRURLSessionManagerTaskDelegate.h
//  PRCollections
//
//  Created by YmWw on 2020/5/2.
//  Copyright © 2020 com.caogenleague.monster. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PRURLSessionManager;
NS_ASSUME_NONNULL_BEGIN

typedef void (^PRURLSessionTaskProgressBlock)(NSProgress *progress);

@interface PRURLSessionManagerTaskDelegate : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
- (instancetype)initWithTask:(NSURLSessionTask *)task;
@property (nonatomic, weak) PRURLSessionManager *manager;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSProgress *uploadProgress;
@property (nonatomic, strong) NSProgress *downloadProgress;
@property (nonatomic, strong) NSURL *downloadFileURL;
@property (nonatomic, copy) PRURLSessionTaskProgressBlock downloadProgressBlock;
@property (nonatomic, copy) PRURLSessionTaskProgressBlock uploadProgressBlock;

@end

NS_ASSUME_NONNULL_END
