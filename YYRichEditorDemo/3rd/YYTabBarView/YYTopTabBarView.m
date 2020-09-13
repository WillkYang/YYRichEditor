/*
 作者：  WillkYang
 文件：  YYTopTabBarView.h
 版本：  1.0 <2016.10.05>
 地址：
 描述：  封装多View选择器
 */
#import <Masonry/Masonry.h>
#import "YYTopTabBarView.h"

static const CGFloat kYYIndicatorViewHeight = 2.f;
static const CGFloat kYYIndicatorViewMinWidth = 16.f;
static const CGFloat kTopBarViewHeight = 44.f;
static const CGFloat kTopBarButtonMinWidth = 56.f;
static const CGFloat kYYTopTabBarViewHeight = 42.f;
static const CGFloat kYYTopTabBarViewWidth = 94.f;

@interface YYTopTabBarView() <UIScrollViewDelegate>

/**
 持有最后选中的按钮
 */
@property (nonatomic, strong) UIButton *lastSelectedBtn;

/**
 标题下方的指示器
 */
@property (nonatomic, strong) UIView *indicatorView;

/**
 持有数据源
 */
@property (nonatomic, copy) NSArray <NSString *>*titleItems;

/**
 scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 按钮排列样式
 */
@property (nonatomic, assign) YYTopBarDistributionStyle distributionStyle;

/**
 按钮类型
 */
@property (nonatomic, assign) YYTopBarContentType contentType;

/**
 指示器类型
 */
@property (nonatomic, assign) YYTopBarIndicatorType indicatorType;

/**
 当前选中的index
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/**
 持有按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArray;

/**
 block回调
 */
@property (copy, nonatomic) YYTopTabBarViewBlock handleBlock;


/**
 指示器宽度
 */
@property (nonatomic, assign) CGFloat indicatorViewWidth;
@end

@implementation YYTopTabBarView

/**
 更新顶部标题数组

 @param titleItems 标题数组
 */
- (void)updateItems:(NSArray <NSString *>*)titleItems {
    _titleItems = titleItems;
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self setupHeadView];
}

/**
 创建YYTopTabBarView视图
 
 @param titleItems 传入标题数组
 @param style 是否限制所有的按钮都在一屏内
 @param handleBlock 点击回调
 @return YYTopBar对象
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)titleItems
            distributionStyle: (YYTopBarDistributionStyle)style
                      handler:(YYTopTabBarViewBlock)handleBlock {
    self = [super init];
    if (self) {
        _handleBlock = handleBlock;
        _titleItems = titleItems;
        _distributionStyle = style;
        [self setupHeadView];
    }
    return self;
}

/**
 创建YYTopTabBarView视图
 
 @param titleItems 传入标题数组
 @param style 是否限制所有的按钮都在一屏内
 @param contentType 按钮为文本或图片
 @param indicatorType 下划线类型
 @param handleBlock 点击回调
 @return YYTopBar对象
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)titleItems
            distributionStyle: (YYTopBarDistributionStyle)style
                  contentType: (YYTopBarContentType)contentType
                indicatorType: (YYTopBarIndicatorType)indicatorType
                      handler:(YYTopTabBarViewBlock)handleBlock {
    self = [super init];
    if (self) {
        _handleBlock = handleBlock;
        _titleItems = titleItems;
        _contentType = contentType;
        _distributionStyle = style;
        _indicatorType = indicatorType;
        [self setupHeadView];
    }
    return self;
}

/**
 初始化顶部按钮
 */
- (void)setupHeadView {
    switch (self.distributionStyle) {
        case YYTopBarDistributionStyleInScreen:
            [self initTopBarInScreen];
            break;
        case YYTopBarDistributionStyleOutScreen:
            [self initTopBarOutScreen];
            break;
        case YYTopBarDistributionStyleOutScreenAlignmentLeft:
            [self initTopBarAlignmentLeft];
            break;
        case YYTopBarDistributionStyleOutScreenAlignmentRight:
            [self initTopBarAlignmentRight];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.distributionStyle == YYTopBarDistributionStyleInScreen) {
        self.scrollView.contentSize = self.scrollView.bounds.size;
    }
}

/**
 初始化顶部按钮在一屏内
 */
- (void)initTopBarInScreen {
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [self bgColor];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //按钮组
        __block UIButton *lastBtn;
        __block UIButton *firstBtn;
        self.btnArray = @[].mutableCopy;
        [self.titleItems enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = self.contentType == YYTopBarContentTypeText ? [self createBtnWithTitle:obj tag:idx+100] : [self createBtnWithImageName:obj tag:idx+100];
            [scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(scrollView);
                make.width.equalTo(scrollView).multipliedBy(1.f/self.titleItems.count);
                make.left.equalTo(lastBtn == nil ? scrollView.mas_left : lastBtn.mas_right);
                make.height.equalTo(@(kTopBarViewHeight - kYYIndicatorViewHeight));
            }];
            if (!lastBtn) firstBtn = btn;
            lastBtn = btn;
        }];
        
        if (self.indicatorType != YYTopBarIndicatorTypeNone) {
            //指示器
            UIView *indicatorView = [UIView new];
            indicatorView.backgroundColor = [self lineSelectedColor];
            [scrollView addSubview:indicatorView];
            self.indicatorView = indicatorView;
            
            [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(kYYIndicatorViewHeight));
                if (self.indicatorType == YYTopBarIndicatorTypeMinWidth) {
                    make.width.equalTo(@(kYYIndicatorViewMinWidth));
                } else if (self.indicatorType == YYTopBarIndicatorTypeMaxWidth) {
                    make.width.equalTo(firstBtn);
                }
                make.top.equalTo(lastBtn.mas_bottom);
                make.centerX.equalTo(firstBtn.mas_centerX);
            }];
        }
        
        scrollView.contentSize = self.frame.size;
        scrollView;
    });
    
    if (self.titleItems && self.titleItems.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateBtnUI:nil newBtn:[self.scrollView.subviews firstObject] animated:NO];
        });
    }
}

/**
 初始化顶部按钮，无一屏限制
 */
- (void)initTopBarOutScreen {
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //按钮组
        __block UIButton *lastBtn;
        __block UIButton *firstBtn;
        [self.titleItems enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [self createBtnWithTitle:obj tag:idx+100];
            [scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(scrollView.mas_top);
                make.height.equalTo(@(kYYTopTabBarViewHeight - kYYIndicatorViewHeight));
                make.width.equalTo(@(kYYTopTabBarViewWidth));
                make.left.equalTo(scrollView).offset(kYYTopTabBarViewWidth * idx);
            }];
            if (!lastBtn) firstBtn = btn;
            lastBtn = btn;
            [self.btnArray addObject:btn];
        }];
        
        //指示器
        if (self.indicatorType != YYTopBarIndicatorTypeNone) {
            UIView *indicatorView = [UIView new];
            indicatorView.backgroundColor = [self lineSelectedColor];
            [scrollView addSubview:indicatorView];
            self.indicatorView = indicatorView;
            
            [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[self textNormalColor]};
                CGSize textSize = [self rectOfNSString:lastBtn.titleLabel.text attribute:attribute].size;
                make.height.equalTo(@(kYYIndicatorViewHeight));
                make.width.equalTo(@(textSize.width));
                make.width.equalTo(firstBtn);
                make.top.equalTo(lastBtn.mas_bottom);
                make.centerX.equalTo(firstBtn.mas_centerX);
            }];
        }
        
        scrollView.contentSize = CGSizeMake(self.titleItems.count * kYYTopTabBarViewWidth, kYYTopTabBarViewHeight);
        scrollView;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBtnUI:nil newBtn:[self.scrollView.subviews firstObject] animated:NO];
    });
}

- (void)initTopBarAlignmentLeft {
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [self bgColor];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        //按钮组
        __block UIButton *lastBtn;
        __block UIButton *firstBtn;
        self.btnArray = @[].mutableCopy;
        [self.titleItems enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = self.contentType == YYTopBarContentTypeText ? [self createBtnWithTitle:obj tag:idx+100] : [self createBtnWithImageName:obj tag:idx+100];
            [scrollView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(scrollView);
                make.width.equalTo(@(kTopBarButtonMinWidth));
                make.left.equalTo(lastBtn == nil ? scrollView.mas_left : lastBtn.mas_right);
                make.height.equalTo(@(kTopBarViewHeight - kYYIndicatorViewHeight));
            }];
            if (!lastBtn) firstBtn = btn;
            lastBtn = btn;
            [self.btnArray addObject:btn];
        }];
        
        if (self.indicatorType != YYTopBarIndicatorTypeNone) {
            //指示器
            UIView *indicatorView = [UIView new];
            indicatorView.backgroundColor = [self lineSelectedColor];
            [scrollView addSubview:indicatorView];
            self.indicatorView = indicatorView;
            
            [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(kYYIndicatorViewHeight));
                if (self.indicatorType == YYTopBarIndicatorTypeMinWidth) {
                    make.width.equalTo(@(kYYIndicatorViewMinWidth * 2));
                } else if (self.indicatorType == YYTopBarIndicatorTypeMaxWidth) {
                    make.width.equalTo(firstBtn);
                }
                make.top.equalTo(lastBtn.mas_bottom);
                make.centerX.equalTo(firstBtn.mas_centerX);
            }];
        }
        
        scrollView.contentSize = self.frame.size;
        scrollView;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBtnUI:nil newBtn:[self.scrollView.subviews firstObject] animated:NO];
    });
}

- (void)initTopBarAlignmentRight {
    
}

/**
 按钮点击事件

 @param btn 被点击的按钮
 */
- (void)didClickBtnAction:(UIButton *)btn {
    if (self.selectedIndex == btn.tag - 100 && !self.replayClickAction) {
        return;
    }
    self.userInteractionEnabled= NO;
    [self updateBtnUI:[self.scrollView viewWithTag:self.selectedIndex+100] newBtn:btn animated:YES];

    //滚动scrollview
    CGFloat willOffsetX = ((btn.frame.origin.x + btn.frame.size.width/2.f) - self.bounds.size.width/2.f);
    [UIView animateWithDuration:.5f animations:^{
        if (willOffsetX < 0) {
            self.scrollView.contentOffset = CGPointZero;
        } else if(willOffsetX + self.scrollView.bounds.size.width > self.scrollView.contentSize.width) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.bounds.size.width, 0);
        } else {
            self.scrollView.contentOffset = CGPointMake(willOffsetX, 0);
        }
    }];
    
    if (self.handleBlock) {
        self.handleBlock(self, btn.tag-100);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled= YES;
    });
}


/**
 选中按钮

 @param index 按钮index
 */
- (void)selectIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self didClickBtnAction:[self.scrollView viewWithTag:index + 100]];
    });
}

/**
 更新UI

 @param oldBtn 原按钮
 @param newBtn 新按钮
 */
- (void)updateBtnUI: (UIButton *)oldBtn newBtn:(UIButton *)newBtn animated:(BOOL)animated {
    if (oldBtn) {
        oldBtn.selected = NO;
        oldBtn.layer.transform = CATransform3DMakeScale(1, 1, 1);
        oldBtn.titleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightRegular];
    }
    
    [newBtn setSelected:YES];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        newBtn.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
        newBtn.titleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
    } completion:^(BOOL finished) {

    }];
    
    if (self.indicatorView) {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(newBtn.mas_centerX);
            make.height.equalTo(@(kYYIndicatorViewHeight));
            if (self.indicatorType == YYTopBarIndicatorTypeMinWidth) {
                make.width.equalTo(@(kYYIndicatorViewMinWidth));
            } else {
                make.width.equalTo(newBtn);
            }
            make.top.equalTo(newBtn.mas_bottom);
        }];
    }
    
    if (animated) {
        [self layoutIfNeeded];
    } else {
        [self layoutIfNeeded];
    }
    
    self.selectedIndex = newBtn.tag-100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y != 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

/**
 创建按钮

 @param title 标题
 @param tag tag

 @return 按钮
 */
- (UIButton *)createBtnWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[self textNormalColor] forState:UIControlStateNormal];
    [btn setTitleColor:[self textSelectedColor] forState:UIControlStateSelected];
    btn.tag = tag;
    [btn addTarget:self action:@selector(didClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

/**
 创建按钮
 
 @param imageName 图片名
 @param tag tag
 
 @return 按钮
 */
- (UIButton *)createBtnWithImageName:(NSString *)imageName tag:(NSInteger)tag
{
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeCenter;
    btn.tag = tag;
    [btn addTarget:self action:@selector(didClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (UIColor *)textNormalColor {
    return [UIColor whiteColor];
}

- (UIColor *)textSelectedColor {
    return [UIColor whiteColor];
}

- (UIColor *)lineSelectedColor {
    return [UIColor colorWithRed:70/255.f green:69/255.f blue:69/255.f alpha:1.f];
}

- (UIColor *)bgColor {
    return [UIColor clearColor];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}
@end
