# PGPickerView
PGPickerView是将UIPickerView的弯曲弧度变成直列表，可以是单列表，多列表，还可以修改选中label的字体颜色等。  
  
![PGPickerView.gif](http://upload-images.jianshu.io/upload_images/1340308-7a18c3fbd338a1fd.gif?imageMogr2/auto-orient/strip)

# Installation with CocoaPods

```
pod 'PGPickerView'
```

# Usage

```
#pragma UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}
#pragma UIPickerViewDelegate
- (nullable NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"label%ld--%ld", component, row];
}
```