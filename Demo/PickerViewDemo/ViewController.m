//
//  ViewController.m
//  PickerViewDemo
//
//  Created by piggybear on 2017/7/26.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "ViewController.h"
#import "PGPickerView.h"

@interface ViewController ()<PGPickerViewDelegate, PGPickerViewDataSource>
@property (nonatomic, weak) IBOutlet PGPickerView *pickerView;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableArray *datas;
@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [self.datas addObject:[NSString stringWithFormat:@"Label%d", i]];
    }
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView selectRow:4 inComponent:0 animated:YES];
    [self.pickerView selectRow:4 inComponent:1 animated:YES];
}

- (IBAction)buttonHandler:(id)sender {
    [self.datas removeAllObjects];
    //设置线条的颜色
    self.pickerView.lineBackgroundColor = [UIColor redColor];
    //设置选中行的字体颜色
    self.pickerView.titleColorForSelectedRow = [UIColor redColor];
    //设置未选中行的字体颜色
    self.pickerView.titleColorForOtherRow = [UIColor blackColor];
    for (int i = 0; i < 10; i++) {
        [self.datas addObject:[NSString stringWithFormat:@"Test%d", i]];
    }
    [self.pickerView reloadComponent:1];
}


#pragma UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datas.count;
}
#pragma UIPickerViewDelegate
//- (UIColor *)pickerView:(PGPickerView *)pickerView viewBackgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (row == 0) {
//        return [UIColor redColor];
//    }else if (row == 1) {
//        return [UIColor orangeColor];
//    }
//    return nil;
//}

- (nullable NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.datas[row];
}

//- (NSAttributedString *)pickerView:(PGPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSAttributedString *restr = [[NSAttributedString alloc] initWithString:@"121212" attributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//    return restr;
//}

- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"row = %ld component = %ld", row, component);
}

//- (CGFloat)rowHeightInPickerView:(PGPickerView *)pickerView {
//    return 50;
//}

@end
