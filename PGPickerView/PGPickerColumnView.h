//
//  PGPickerColumnView.h
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGPickerColumnViewDelegate;

@interface PGPickerColumnView : UIView
@property (nonatomic, weak) id<PGPickerColumnViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger component;
@property (nonatomic, strong) NSArray<UIColor *> *viewBackgroundColors;
@property (nonatomic, assign) NSUInteger selectedRow;
@property (nonatomic, strong)UIColor *selectedRowTitleColor;
@property (nonatomic, strong)UIColor *otherRowTitleColor;

- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas;
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;
@end

@protocol PGPickerColumnViewDelegate<NSObject>
@optional
- (void)pickerColumnView:(PGPickerColumnView *)pickerColumnView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
