@interface LinkPreview : NSObject

- (void) generateLinkPreview:(NSString *)inputUrl completionHandler:(void (^)(NSMutableDictionary *responseDictionary))completion;
- (void) handleYoutubeLink:(NSString *)inputUrl completionHandler:(void (^)(NSMutableDictionary *responseDictionary))completion;

@end
