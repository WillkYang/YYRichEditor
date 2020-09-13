//
//  YYEditorAlignTableViewCell.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYStyleSettings;

//typedef enum : NSUInteger {
//    YYEditorAlignTypeLeft,
//    YYEditorAlignTypeCenter,
//    YYEditorAlignTypeRight,
//} YYEditorAlignType;

@protocol YYEditorAlignDelegate <NSObject>
- (void)yy_editorAlignChangeType:(NSTextAlignment)type;
@end

@interface YYEditorAlignTableViewCell : UITableViewCell

@property (nonatomic, assign) NSTextAlignment type;
@property (nonatomic, weak) id<YYEditorAlignDelegate> delegate;

- (void)updateWithAlignment:(NSTextAlignment)alignment;
@end
