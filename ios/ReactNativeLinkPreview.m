#import "ReactNativeLinkPreview.h"
#import "LKLinkPreviewKit.h"

#import <React/RCTLog.h>
    
@implementation ReactNativeLinkPreview

RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios

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
    NSURL *URL = [NSURL URLWithString:inputUrl];

    
    [LKLinkPreviewReader linkPreviewFromURL:URL completionHandler:^(NSArray *previews, NSError *error) {
        if (previews.count > 0  && ! error) {
            LKLinkPreview *preview = [previews firstObject];
            
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            
            [result setValue:preview.title forKey:@"title"];
            [result setValue:preview.type forKey:@"type"];
            [result setValue:preview.URL.absoluteString forKey:@"url"];
            [result setValue:preview.imageURL.absoluteString forKey:@"imageURL"];
            [result setValue:preview.linkDescription forKey:@"description"];
            
            resolve(result);
        }
    }];
    
}

@end
