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
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        
        for(NSURLSessionDataTask *dataTask in dataTasks) {
            [self addDelegateForDataTask:dataTask uploadProgress:nil downloadProgress:nil completionHandler:nil];
        }
        
        for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
            [self addDelegateForUploadTask:uploadTask uploadProgress:nil completionHandler:nil];
        }
        
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
            [self addDelegateForDownloadTask:downloadTask downloadProgress:nil completionHandler:nil];
        }
        
    }];
    return self;
    
}

- (void)setDelegate:(PRURLSessionManagerTaskDelegate*)delegate ForTask:(NSURLSessionTask *)task {
    
    NSParameterAssert(delegate);
    NSParameterAssert(task);
    [self.lock lock];
    self.taskDelegateKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
    [self.lock unlock];
}

- (void)addDelegateForDataTask:(NSURLSessionDataTask *)dataTask
                uploadProgress:(NSProgress *)uploadProgress
              downloadProgress:(NSProgress *)downloadProgress
             completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completeHandler {
    
    PRURLSessionManagerTaskDelegate *delegate = [[PRURLSessionManagerTaskDelegate alloc] initWithTask:dataTask];
    delegate.manager = self;
    delegate.completeBlock = completeHandler;
    delegate.uploadProgress = uploadProgress;
    delegate.downloadProgress = downloadProgress;
    [self setDelegate:delegate ForTask:dataTask];
    
}

- (void)addDelegateForUploadTask:(NSURLSessionUploadTask *)uploadTask
                  uploadProgress:(NSProgress *)uploadProgress
               completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completeHandler {
    
    PRURLSessionManagerTaskDelegate *delegate = [[PRURLSessionManagerTaskDelegate alloc] initWithTask:uploadTask];
    delegate.manager = self;
    delegate.completeBlock = completeHandler;
    delegate.uploadProgress = uploadProgress;
    [self setDelegate:delegate ForTask:uploadTask];
}

- (void)addDelegateForDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                  downloadProgress:(NSProgress *)downloadProgress
               completionHandler:(void(^)(NSURLResponse *response, id responseObject, NSError *error))completeHandler {
    
    PRURLSessionManagerTaskDelegate *delegate = [[PRURLSessionManagerTaskDelegate alloc] initWithTask:downloadTask];
    delegate.manager = self;
    delegate.completeBlock = completeHandler;
    delegate.downloadProgress = downloadProgress;
    [self setDelegate:delegate ForTask:downloadTask];
}



@end

