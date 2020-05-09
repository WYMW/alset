//
//  PRURLSessionManager.m
//  PRCollections
//
//  Created by Barry on 2020/5/1.
//  Copyright © 2020 Barry. All rights reserved.
//

//#pragma TODO did not  add  _AFURLSessionTaskSwizzling

#import "PRURLSessionManager.h"

static NSString * const PRSessionManagerLockName = @"com.csgday.session.manager.name";

@interface PRURLSessionManager()
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;
@property (readwrite, nonatomic, strong) NSMutableDictionary *taskDelegateKeyedByTaskIdentifier;
@property (nonatomic, strong) NSLock *lock;
@end
@implementation PRURLSessionManager

-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = NSURLSessionConfiguration.defaultSessionConfiguration;
    }
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    self.taskDelegateKeyedByTaskIdentifier = [[NSMutableDictionary alloc] init];
    self.lock = [[NSLock alloc] init];
    self.lock.name = PRSessionManagerLockName;
    self.taskDelegateKeyedByTaskIdentifier = [[NSMutableDictionary alloc] init];
    return self;
    
}

@end

