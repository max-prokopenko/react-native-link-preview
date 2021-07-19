#import "ReactNativeLinkPreview.h"
#import "LKLinkPreviewKit.h"

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
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSURL *URL = [NSURL URLWithString:inputUrl];
    
    if(URL == nil) {
        [result setValue:@"error" forKey:@"status"];
        [result setValue:@"Link url is malformed" forKey:@"message"];
        return resolve(result);
    }

    
    [LKLinkPreviewReader linkPreviewFromURL:URL completionHandler:^(NSArray *previews, NSError *error) {
        
        
        if (previews.count > 0  && ! error) {
            LKLinkPreview *preview = [previews firstObject];
                                    
            [result setValue:@"success" forKey:@"status"];
            [result setValue:@"Link preview was successfully fetched" forKey:@"message"];
            [result setValue:preview.title forKey:@"title"];
            [result setValue:preview.type forKey:@"type"];
            [result setValue:preview.URL.absoluteString forKey:@"url"];
            [result setValue:preview.imageURL.absoluteString forKey:@"imageURL"];
            [result setValue:preview.linkDescription forKey:@"description"];
        } else {
            [result setValue:@"error" forKey:@"status"];
            [result setValue:@"Link preview fetching failed" forKey:@"message"];
        }
        return resolve(result);
    }];
    
}

@end
