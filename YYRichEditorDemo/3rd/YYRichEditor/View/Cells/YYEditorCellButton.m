//
//  YYEditorCellButton.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYEditorCellButton.h"

@implementation YYEditorCellButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.tintColor = [UIColor colorWithRed:0 green:204/255.f blue:187.f/255.f alpha:1.f];
    } else {
        self.tintColor = [UIColor blackColor];
    }
}

@end
