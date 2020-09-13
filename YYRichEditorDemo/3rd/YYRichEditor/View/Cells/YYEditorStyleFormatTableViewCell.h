//
//  YYEditorStyleFormatTableViewCell.h
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYStyleSettings;
@class YYTextStyle;

@interface YYEditorStyleFormatTableViewCell : UITableViewCell
@property (nonatomic, weak) id<YYStyleSettings> delegate;
//@property (nonatomic, assign) BOOL bold;
//@property (nonatomic, assign) BOOL italic;
//@property (nonatomic, assign) BOOL underline;

- (void)updateWithTextStyle:(YYTextStyle *)textStyle;

@end
