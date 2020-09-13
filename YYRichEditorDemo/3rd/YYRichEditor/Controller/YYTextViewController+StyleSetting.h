//
//  YYTextViewController+StyleSetting.h
//  YYNote
//
//  Created by WillkYang on 2017/8/12.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYTextViewController.h"
#import "YYStyleSettingsController.h"

@interface YYTextViewController (StyleSetting) <YYStyleSettingsControllerDelegate>

- (void)updateTextStyleTypingAttributes;

- (void)updateParagraphTypingAttributes;

- (void)reloadSettingsView;
@end
