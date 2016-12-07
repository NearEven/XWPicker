//
//  XWPicker.h
//  XWPickerView
//
//  Created by  HYY on 16/12/7.
//  Copyright © 2016年  HYY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void  (^XWCompleteBlock)(NSString *str);

@interface XWPicker : UIButton


/**
 显示pickerView
 @param titles 数组标题
 @param selectedTitle 默认选中的标题
 @param block 返回选中的标题
 */
+ (void)showPickerWithTitles:(NSArray *)titles
           selectedTitle:(NSString *)selectedTitle
           completeBlock:(XWCompleteBlock)block;

@end
