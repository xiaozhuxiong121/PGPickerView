//
//  PGPickerView.m
//  PGPickerView
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGPickerView.h"
#import "PGPickerViewMacros.h"
#import "PGPickerColumnView.h"
#import "PGPickerViewConfig.h"

@interface PGPickerView()<PGPickerColumnViewDelegate>
@property (nonatomic, weak) UIView *upLine;
@property (nonatomic, weak) UIView *downLine;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSArray<PGPickerColumnView *> *columnViewList;
@end

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
@implementation PGPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.lineBackgroundColor = [UIColor grayColor];
        self.selectedRowTitleColor = [UIColor blackColor];
        self.otherRowTitleColor = [UIColor grayColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        self.lineBackgroundColor = [UIColor grayColor];
        self.selectedRowTitleColor = [UIColor blackColor];
        self.otherRowTitleColor = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.downLine];
    [self bringSubviewToFront:self.upLine];
}

- (void)setupColumnView {
    CGFloat width = kWidth / _numberOfComponents;
    NSMutableArray *columnViewList = [NSMutableArray arrayWithCapacity:_numberOfComponents];
    for (int i = 0; i < _numberOfComponents; i++) {
        NSUInteger row = [self.dataSource pickerView:self numberOfRowsInComponent:i];
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:row];
        NSMutableArray *colors = [NSMutableArray arrayWithCapacity:row];
        for (int j = 0; j < row; j++) {
            BOOL tf = true;
            NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:@"?"];
            UIColor *color = [UIColor clearColor];
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)]) {
                    attriStr = [self.delegate pickerView:self attributedTitleForRow:j forComponent:i];
                    if (!attriStr) {
                        tf = false;
                    }
                }else {
                    tf = false;
                }
                if (!tf && [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                    NSString *title = [self.delegate pickerView:self titleForRow:j forComponent:i];
                    title = title ? title : @"?";
                    attriStr = [[NSAttributedString alloc]initWithString:title];
                }
                
                if ([self.delegate respondsToSelector:@selector(pickerView:viewBackgroundColorForRow:forComponent:)]) {
                    UIColor *temp = [self.delegate pickerView:self viewBackgroundColorForRow:j forComponent:i];
                    if (temp) {
                        color = temp;
                    }
                }
            }
            [colors addObject:color];
            [datas addObject:attriStr];
        }
        PGPickerColumnView *view = [[PGPickerColumnView alloc]initWithFrame:CGRectMake(i * width, 0, width, kHeight) datas:datas];
        view.delegate = self;
        view.viewBackgroundColors = colors;
        view.component = i;
        view.selectedRowTitleColor = self.selectedRowTitleColor;
        view.otherRowTitleColor = self.otherRowTitleColor;
        [self addSubview:view];
        [columnViewList addObject:view];
    }
    self.columnViewList = columnViewList;
}

- (void)setupView {
    CGFloat upLinePosY = kHeight / 2 - [PGPickerViewConfig instance].tableViewHeightForRow / 2 - kLineHeight;
    CGFloat downLinePosY = kHeight / 2 + [PGPickerViewConfig instance].tableViewHeightForRow / 2 - kLineHeight;
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, upLinePosY, kWidth, kLineHeight)];
    upLine.backgroundColor = self.lineBackgroundColor;
    [self addSubview:upLine];
    self.upLine = upLine;
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, downLinePosY, kWidth, kLineHeight)];
    downLine.backgroundColor = self.lineBackgroundColor;
    [self addSubview:downLine];
    self.downLine = downLine;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [self.dataSource pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    if (view) {
        return view.selectedRow;
    }
    return -1;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    PGPickerColumnView *view = [self columnViewInComponent:component];
    [view selectRow:row animated:animated];
}

- (PGPickerColumnView *)columnViewInComponent:(NSUInteger)component {
    if (!self.columnViewList || self.columnViewList.count == 0) {
        return nil;
    }
    __block PGPickerColumnView *view = nil;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.component == component) {
            view = obj;
            *stop = true;
        }
    }];
    return view;
}

#pragma mark - PGPickerColumnViewDelegate
- (void)pickerColumnView:(PGPickerColumnView *)pickerColumnView didSelectRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:row inComponent:pickerColumnView.component];
    }
}

#pragma mark - Setter
- (void)setDataSource:(id<PGPickerViewDataSource>)dataSource {
    _dataSource = dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        _numberOfComponents = [dataSource numberOfComponentsInPickerView:self];
    }
    [self setupColumnView];
    [self setupView];
}

- (void)setDelegate:(id<PGPickerViewDelegate>)delegate {
    _delegate = delegate;
    if (delegate && [delegate respondsToSelector:@selector(rowHeightInPickerView:)]) {
        [PGPickerViewConfig instance].tableViewHeightForRow = [delegate rowHeightInPickerView:self];
    }else {
        [PGPickerViewConfig instance].tableViewHeightForRow = 50;
    }
}

- (void)setLineBackgroundColor:(UIColor *)lineBackgroundColor {
    _lineBackgroundColor = lineBackgroundColor;
    self.upLine.backgroundColor = lineBackgroundColor;
    self.downLine.backgroundColor = lineBackgroundColor;
}

- (void)setSelectedRowTitleColor:(UIColor *)selectedRowTitleColor {
    _selectedRowTitleColor = selectedRowTitleColor;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectedRowTitleColor = selectedRowTitleColor;
    }];
}

- (void)setOtherRowTitleColor:(UIColor *)otherRowTitleColor {
    _otherRowTitleColor = otherRowTitleColor;
    [self.columnViewList enumerateObjectsUsingBlock:^(PGPickerColumnView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.otherRowTitleColor = otherRowTitleColor;
    }];
}

#pragma mark - Getter
- (NSUInteger)numberOfRows {
    if (!_numberOfRows) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
            _numberOfRows = [self.dataSource pickerView:self numberOfRowsInComponent:_numberOfComponents];
        }else {
            _numberOfRows = 0;
        }
    }
    return _numberOfRows;
}

@end
