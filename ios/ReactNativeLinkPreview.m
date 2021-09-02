#import "ReactNativeLinkPreview.h"
#import "LinkPreview.h"

#import <React/RCTLog.h>
    
@implementation ReactNativeLinkPreview

RCT_EXPORT_MODULE()


+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_REMAP_METHOD(generate,
                 generate:(nonnull NSString*)inputUrl
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    [[LinkPreview alloc] generateLinkPreview:inputUrl completionHandler:^(NSMutableDictionary *responseDictionary) {
        resolve(responseDictionary);
    }];
    
}

@end
