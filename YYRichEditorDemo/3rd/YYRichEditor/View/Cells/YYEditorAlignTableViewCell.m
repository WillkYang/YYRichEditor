//
//  YYEditorAlignTableViewCell.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//

#import "YYEditorAlignTableViewCell.h"
#import "YYEditorCellButton.h"

@interface YYEditorAlignTableViewCell()
@property (nonatomic, weak) IBOutlet YYEditorCellButton *alignLeftButton;
@property (nonatomic, weak) IBOutlet YYEditorCellButton *alignCenterButton;
@property (nonatomic, weak) IBOutlet YYEditorCellButton *alignRightButton;
@property (nonatomic, weak) UIButton *lastSelectedButton;
@end

@implementation YYEditorAlignTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buttonClick:self.alignLeftButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)buttonClick:(id)button {
    if (button == self.lastSelectedButton) {
        return;
    }
    [self.lastSelectedButton setSelected:NO];
    [button setSelected:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_editorAlignChangeType:)]) {
        if (self.alignLeftButton == button) self.type = NSTextAlignmentLeft;
        if (self.alignCenterButton == button) self.type = NSTextAlignmentCenter;
        if (self.alignRightButton == button) self.type = NSTextAlignmentRight;
        [self.delegate yy_editorAlignChangeType:self.type];
    }
    self.lastSelectedButton = button;
}

- (void)updateWithAlignment:(NSTextAlignment)alignment {
    [self.alignLeftButton setSelected:NO];
    [self.alignCenterButton setSelected:NO];
    [self.alignRightButton setSelected:NO];
    switch (alignment) {
        case NSTextAlignmentLeft:
            [self.alignLeftButton setSelected:YES];
            break;
        case NSTextAlignmentCenter:
            [self.alignCenterButton setSelected:YES];
            break;
        case NSTextAlignmentRight:
            [self.alignRightButton setSelected:YES];
            break;
        default:
            break;
    }
}
@end
