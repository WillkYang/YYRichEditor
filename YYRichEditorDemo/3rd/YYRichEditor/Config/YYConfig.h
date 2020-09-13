//
//  YYConfig.h
//  YYRichEditorDemo
//
//  Created by WillkYang on 2017/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kYNFontName = @"PingFang TC";
static NSString *kYNBoldFontName = @"PingFangTC-SemiBold";

@interface YYConfig: NSObject

+ (NSString *)imageLocalPath;

+ (NSString *)imageHostURL;

@end

NS_ASSUME_NONNULL_END
