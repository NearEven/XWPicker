//
//  XWPicker.m
//  XWPickerView
//
//  Created by  HYY on 16/12/7.
//  Copyright © 2016年  HYY. All rights reserved.
//

#import "XWPicker.h"
#define kWIDTH ([UIScreen mainScreen].bounds.size.width)
#define kHEIGHT ([UIScreen mainScreen].bounds.size.height)
static const int HeightPicker = 240;
static const int HeightToobar = 40;

@interface XWPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSArray *mTitles;
@property(nonatomic,strong)NSString *mTitleSelected;
@property(nonatomic, copy)XWCompleteBlock mBlockComplete;



@property(nonatomic,strong)UIView *mViewContent;
@property(nonatomic,strong)UIView *mViewLine;
@property(nonatomic,strong)UIPickerView *mViewPicker;
@property(nonatomic,strong)UIButton *mBtnRight;
@property(nonatomic,strong)UIButton *mBtnLeft;
@property(nonatomic,strong)UILabel *mLabTitle;

@property(nonatomic,strong)NSString *mTitle;


@end

@implementation XWPicker
+ (void)showPickerWithTitles:(NSArray *)titles selectedTitle:(NSString *)selectedTitle completeBlock:(XWCompleteBlock)block{
    XWPicker *picker = [XWPicker new];
    picker.mTitles = titles;
    picker.mTitle = selectedTitle;
    picker.mBlockComplete = block;
    picker.mBlockComplete(titles[0]);
    [picker setDefault];
    [picker configView];
    [picker show];
}

- (void)setDefault{
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102/255];
    self.layer.opacity = 0.0;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
}

// 初始化view
- (void)configView{
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT, kWIDTH, HeightPicker)];
    viewContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewContainer];
    self.mViewContent = viewContainer;
    
    // 分隔线
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, HeightToobar)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [viewContainer addSubview:viewLine];
    
    // 确定
    UIButton *btnEnsure = [[UIButton alloc] initWithFrame:CGRectMake(kWIDTH-70, 5, 40, 30)];
    btnEnsure.titleLabel.font = [UIFont systemFontOfSize:18];
    [btnEnsure setTitle:@"确定" forState:UIControlStateNormal];
    [btnEnsure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnEnsure addTarget:self action:@selector(btnEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [viewContainer addSubview:btnEnsure];
    
    // 取消
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 40, 30)];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:18];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [viewContainer addSubview:btnCancel];
    [viewContainer addSubview:btnCancel];
    
    // pickerView
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 32, kWIDTH, HeightPicker-HeightToobar)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    [viewContainer addSubview:picker];
}

#pragma mark - targetAction
- (void)btnEnsureAction{
    if (self.mBlockComplete) {
        self.mBlockComplete(self.mTitle);
    }
    [self remove];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frame = self.mViewContent.frame;
    frame.origin.y -= self.mViewContent.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.layer.opacity = 1.0;
        self.mViewContent.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)remove{
    CGRect frame = self.mViewContent.frame;
    frame.origin.y += self.mViewContent.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.layer.opacity = 0.0;
        self.mViewContent.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - pickerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.mTitles.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.mTitle = self.mTitles[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for (UIView *viewline in pickerView.subviews) {
        if (viewline.frame.size.height<1) {
            viewline.backgroundColor = [UIColor clearColor];
        }
    }
    UILabel *labelTitle = [UILabel new];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = self.mTitles[row];
    labelTitle.font = [UIFont systemFontOfSize:23];
    labelTitle.textColor = [UIColor blackColor];
    return labelTitle;
}

@end
