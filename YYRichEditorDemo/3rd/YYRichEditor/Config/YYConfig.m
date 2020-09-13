//
//  YYConfig.m
//  YYRichEditorDemo
//
//  Created by WillkYang on 2017/9/13.
//

#import "YYConfig.h"

@implementation YYConfig

+ (NSString *)imageLocalPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dirPath = [NSString stringWithFormat:@"%@/imgs/", path];
    return dirPath;
}


+ (NSString *)imageHostURL {
    return @"http://xxx.xxx";
}
@end
