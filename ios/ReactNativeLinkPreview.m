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
    
    NSString *youtubeMatcher = @"youtube.com/";
    NSString *youtubeMatcherShort = @"youtu.be/";
    if ((!([inputUrl rangeOfString:youtubeMatcher].location == NSNotFound)) || (!([inputUrl rangeOfString:youtubeMatcherShort].location == NSNotFound))) {
        return [self handleYoutubeLink:inputUrl resolve:resolve];
    }
    
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

-(void)handleYoutubeLink:(NSString *)inputUrl resolve:(RCTPromiseResolveBlock)resolve {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *youtubeMetadataUrl = [[@"https://youtube.com/oembed?url=" stringByAppendingString:inputUrl] stringByAppendingString:@"&format=json"];
    NSURL *URL = [NSURL URLWithString:youtubeMetadataUrl];
    
    if(URL == nil) {
        [result setValue:@"error" forKey:@"status"];
        [result setValue:@"Link url is malformed" forKey:@"message"];
        return resolve(result);
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode = 404;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            statusCode = [(NSHTTPURLResponse *)response statusCode];
        }
        if (error || statusCode != 200) {
            if (statusCode != 200 && error == nil) {
                [result setValue:@"error" forKey:@"status"];
                [result setValue:@"Link preview fetching failed" forKey:@"message"];
            }
            return resolve(result);
        }
        
        // Success
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                [result setValue:@"error" forKey:@"status"];
                [result setValue:@"Link preview fetching failed" forKey:@"message"];
                resolve(result);
            } else {
                [result setValue:@"success" forKey:@"status"];
                [result setValue:@"Link preview was successfully fetched" forKey:@"message"];
                [result setValue:jsonResponse[@"title"] forKey:@"title"];
                [result setValue:@"youtube" forKey:@"type"];
                [result setValue:inputUrl forKey:@"url"];
                [result setValue:jsonResponse[@"thumbnail_url"] forKey:@"imageURL"];
                [result setValue:jsonResponse[@"author_name"] forKey:@"description"];
                return resolve(result);
            }
        }
            
        
    }] resume];
}

@end
