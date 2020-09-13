//
//  ViewController.m
//  YYRichEditorDemo
//
//  Created by WillkYang on 2020/9/13.
//

#import "ViewController.h"
#import "YYTextViewController.h"
#import <Masonry/Masonry.h>

@interface ViewController () <YYRichEditorDelegate>
@property (strong, nonatomic) YYTextViewController *textVc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textVc = [[YYTextViewController alloc] init];
    self.textVc.delegate = self;
    [self addChildViewController:self.textVc];
    [self.view addSubview:self.textVc.view];
    [self.textVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.textVc.textView becomeFirstResponder];
}

// 点击完成按钮回调, 在此处进行数据相关保存操作
- (void)yy_editorDoneWithContentArray:(NSArray <YYTextItem *> *)contentArray originString:(NSString *)string {
    NSLog(@"保存数组: %@", contentArray);
    NSLog(@"%@", string);
}

// 选择完图片之后, 进行图片转换操作
- (NSString *)yy_saveImage:(UIImage *)image {
    NSLog(@"保存图片...");
    return @"";
}

@end
