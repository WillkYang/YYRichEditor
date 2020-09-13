//
//  YYTextItem.h
//  YYLib
//
//  Created by WillkYang on 2017/8/9.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface YYTextItem : NSObject 

// index
@property (nonatomic, assign) NSInteger I;
// align
@property (nonatomic, assign) NSInteger A;
// size
@property (nonatomic, assign) NSInteger S;
// hexcolor
@property (nonatomic, copy) NSString *C;
// isBold
@property (nonatomic, assign) BOOL B;
// isPicture
@property (nonatomic, assign) BOOL P;
// underline
@property (nonatomic, assign) BOOL U;
// italic
@property (nonatomic, assign) BOOL X;
// text
@property (nonatomic, copy) NSString *T;
// width
@property (nonatomic, assign) CGFloat W;
// height
@property (nonatomic, assign) CGFloat H;
// file
@property (nonatomic, copy) NSString *F;


@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, copy) NSString *imageUrlDisp;
@property (nonatomic, strong) UIImage *getImageSync;

+ (instancetype)yy_textItemWithString:(NSString *)string sttributes:(NSDictionary *)attributes;

+ (instancetype)yy_textItemWithImageUrl:(NSString *)imageUrl width:(CGFloat)width height:(CGFloat)height;

- (NSAttributedString *)yy_toString;

// 图片本地可能没有，所以使用反向图片设置
- (void)setImageWithImageView:(UIImageView *)imageView;

@end
