//
//  YYEditorFontColorTableViewCell.m
//  YYLib
//
//  Created by WillkYang on 2017/8/7.
//  Copyright © 2017年 WillkYang. All rights reserved.
//
#import "YYEditorFontColorTableViewCell.h"
#import "YYStyleSettings.h"
#import "YYTextStyle.h"

@interface YYEditorFontColorCollectionViewCell:UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation YYEditorFontColorCollectionViewCell

@end

@interface YYEditorFontColorTableViewCell() <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *selectedColorView;
@end

@implementation YYEditorFontColorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _colors = @[
                [self colorWithHex:0xffffff andAlpha:1.f],
                [self colorWithHex:0x2C2D34 andAlpha:1.f],
                [self colorWithHex:0xE3E3E3 andAlpha:1.f],
                [self colorWithHex:0x00E0FF andAlpha:1.f],
                [self colorWithHex:0x30E3CA andAlpha:1.f],
                [self colorWithHex:0x625772 andAlpha:1.f],
                [self colorWithHex:0x7E6BC4 andAlpha:1.f],
                [self colorWithHex:0x4D606E andAlpha:1.f],
                [self colorWithHex:0xF38181 andAlpha:1.f],
                [self colorWithHex:0xFF9DE2 andAlpha:1.f],
                [self colorWithHex:0x000000 andAlpha:1.f],
                [self colorWithHex:0xF3F798 andAlpha:1.f],
                [self colorWithHex:0xE45A84 andAlpha:1.f],
                ];
    self.selectedColorView.backgroundColor = self.colors.firstObject;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YYEditorFontColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYEditorFontColorCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.colors[indexPath.item];
    cell.imageView.hidden = indexPath.item == self.currentIndex ? NO : YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self updateUIWithItemIndex:indexPath.item];
//    self.currentIndex = indexPath.item;
//    self.selectedColorView.backgroundColor = self.colors[indexPath.item];
//    [collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(yy_didChangedStyleSettings:)]) {
        [self.delegate yy_didChangedStyleSettings:@{YYStyleSettingsTextColorName:self.colors[indexPath.item]}];
    }
}

- (void)updateWithTextStyle:(YYTextStyle *)textStyle {
    if ([self.colors indexOfObject:textStyle.textColor] != NSNotFound) {
        [self updateUIWithItemIndex:[self.colors indexOfObject:textStyle.textColor]];
    }
}

- (void)updateUIWithItemIndex:(NSInteger)index {
    self.currentIndex = index;
    self.selectedColorView.backgroundColor = self.colors[index];
    [self.collectionView reloadData];
}
@end

