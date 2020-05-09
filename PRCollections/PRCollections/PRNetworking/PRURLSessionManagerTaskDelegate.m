//
//  PRURLSessionManagerTaskDelegate.m
//  PRCollections
//
//  Created by YmWw on 2020/5/2.
//  Copyright © 2020 com.caogenleague.monster. All rights reserved.
//

#import "PRURLSessionManagerTaskDelegate.h"
@implementation PRURLSessionManagerTaskDelegate
- (instancetype)initWithTask:(NSURLSessionTask *)task {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    self.mutableData = [[NSMutableData alloc] init];
    self.uploadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    self.downloadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    for (NSProgress *progress in @[_uploadProgress, _downloadProgress]) {
        
        progress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        progress.cancellable = YES;
        progress.cancellationHandler = ^{
            [task cancel];
        };
        progress.pausable = YES;
        progress.pausingHandler = ^{
            [task suspend];
        };
        progress.resumingHandler = ^{
            [task resume];
        };
        [progress addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))  options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    // The original use `isEqual` try to get the different
    if (object == self.downloadProgress) {
        if (self.downloadProgressBlock) {
            self.downloadProgressBlock(object);
        }
    } else if (object == self.uploadProgress){
        if (self.uploadProgressBlock) {
            self.uploadProgressBlock(object);
        }
    }
}


- (void)dealloc {
    [self.downloadProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
    [self.uploadProgress removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
}

@end
