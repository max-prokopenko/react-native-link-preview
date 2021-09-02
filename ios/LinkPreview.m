#import "LinkPreview.h"
#import "LKLinkPreviewKit.h"
    
@implementation LinkPreview

- (void) generateLinkPreview:(NSString *)inputUrl completionHandler:(void (^)(NSMutableDictionary *responseDictionary))completion {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *youtubeMatcher = @"youtube.com/";
    NSString *youtubeMatcherShort = @"youtu.be/";
    if ((!([inputUrl rangeOfString:youtubeMatcher].location == NSNotFound)) || (!([inputUrl rangeOfString:youtubeMatcherShort].location == NSNotFound))) {
        return [self handleYoutubeLink:inputUrl completionHandler:^(NSMutableDictionary *responseDictionary) {
             return completion(responseDictionary);
        }];
    }
    
    NSURL *URL = [NSURL URLWithString:inputUrl];
    
    if(URL == nil) {
        [result setValue:@"error" forKey:@"status"];
        [result setValue:@"Link url is malformed" forKey:@"message"];
        return completion(result);
    }
    
    [LKLinkPreviewReader linkPreviewFromURL:URL completionHandler:^(NSArray *previews, NSError *error) {
            
        if (previews.count > 0 && ! error) {
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
        return completion(result);
    }];
}

- (void)handleYoutubeLink:(NSString *)inputUrl completionHandler:(void (^)(NSMutableDictionary *responseDictionary))completion {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *youtubeMetadataUrl = [[@"https://youtube.com/oembed?url=" stringByAppendingString:inputUrl] stringByAppendingString:@"&format=json"];
    NSURL *URL = [NSURL URLWithString:youtubeMetadataUrl];
    
    if(URL == nil) {
        [result setValue:@"error" forKey:@"status"];
        [result setValue:@"Link url is malformed" forKey:@"message"];
        completion(result);
        return;
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
                completion(result);
                return;
            }
        }
        
        // Success
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                [result setValue:@"error" forKey:@"status"];
                [result setValue:@"Link preview fetching failed" forKey:@"message"];
            } else {
                [result setValue:@"success" forKey:@"status"];
                [result setValue:@"Link preview was successfully fetched" forKey:@"message"];
                [result setValue:jsonResponse[@"title"] forKey:@"title"];
                [result setValue:@"youtube" forKey:@"type"];
                [result setValue:inputUrl forKey:@"url"];
                [result setValue:jsonResponse[@"thumbnail_url"] forKey:@"imageURL"];
                [result setValue:jsonResponse[@"author_name"] forKey:@"description"];
            }
            completion(result);
            return;
        }
    }] resume];
}

@end
