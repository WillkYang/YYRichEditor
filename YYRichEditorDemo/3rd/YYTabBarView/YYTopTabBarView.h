/*
 作者：  WillkYang
 文件：  YYTopTabBarView.h
 版本：  1.0 <2016.10.05>
 地址：
 描述：  封装多View选择器
 */

#import <UIKit/UIKit.h>
@class YYTopTabBarView;

typedef NS_ENUM(NSUInteger, YYTopBarDistributionStyle) {
    YYTopBarDistributionStyleInScreen = 1,
    YYTopBarDistributionStyleOutScreen,
    YYTopBarDistributionStyleOutScreenAlignmentLeft,
    YYTopBarDistributionStyleOutScreenAlignmentRight,
};

typedef enum : NSUInteger {
    YYTopBarContentTypeText, // default
    YYTopBarContentTypeImage,
} YYTopBarContentType;

typedef enum : NSUInteger {
    YYTopBarIndicatorTypeNone, // default
    YYTopBarIndicatorTypeMinWidth,
    YYTopBarIndicatorTypeMaxWidth,
} YYTopBarIndicatorType;


/**
 block回调
 
 @param topBarView YYTopTabBarView对象自身
 @param index    选中的文本索引:  0.1.2...
 */
typedef void(^YYTopTabBarViewBlock)(YYTopTabBarView *topBarView, NSInteger index);

@interface YYTopTabBarView : UIView

/**
 重复点击同一个按钮时是否一直反应
 */
@property (nonatomic, assign) BOOL replayClickAction;

/**
 创建YYTopTabBarView视图

 @param titleItems 传入标题数组
 @param style 是否限制所有的按钮都在一屏内
 @param handleBlock 点击回调
 @return YYTopBar对象
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)titleItems
            distributionStyle: (YYTopBarDistributionStyle)style
                      handler:(YYTopTabBarViewBlock)handleBlock;

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
                      handler:(YYTopTabBarViewBlock)handleBlock;

/**
 选中按钮
 
 @param index 按钮index = 0,1,...
 */
- (void)selectIndex:(NSInteger)index;

/**
 更新顶部标题数组
 
 @param titleItems 标题数组
 */
- (void)updateItems:(NSArray <NSString *>*)titleItems;
@end
