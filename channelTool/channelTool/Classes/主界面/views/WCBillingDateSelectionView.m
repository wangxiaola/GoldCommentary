//
//  WCBillingDateSelectionView.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/24.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCBillingDateSelectionView.h"
#import "UIView+MJAlertView.h"

#define mScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight  ([UIScreen mainScreen].bounds.size.height)

#define HEIGHT_COLOR [UIColor colorWithRed:247/255.0 green:160/255.0 blue:44/255.0 alpha:1]
#define DISABLED_COLOR [UIColor colorWithRed:223/255.0 green:224/255.0 blue:225/255.0 alpha:1]

@interface WCBillingDateSelectionView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *dateConversionButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UIView *endDateLineView;
@property (weak, nonatomic) IBOutlet UIView *startDateLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhiCenterXValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBackBottomValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBackHeightValue;
//  是否为startDateTextField赋值
@property (nonatomic, assign) BOOL isStartTextField;

//保存年月日数据的array
@property (nonatomic,strong) NSMutableArray *yearArray;
@property (nonatomic,strong) NSMutableArray *monthArray;
@property (nonatomic,strong) NSMutableArray *dayArray;
//选中的当前行
@property (nonatomic,assign) int selectedRowYear;
@property (nonatomic,assign) int selectedRowMonth;
@property (nonatomic,assign) int selectedRowDay;
//每个月的天数
@property (nonatomic,assign) int dayNumber;
//应该跟新天数了,当月份或年份被选择过或是刚进入为true，需要刷新day
@property (nonatomic,assign) Boolean dayShouldChangeEnable;

@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *day;

@end

@implementation WCBillingDateSelectionView
- (NSMutableArray *)yearArray
{
    if (!_yearArray) {
        _yearArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _yearArray;
}
- (NSMutableArray *)monthArray
{
    if (!_monthArray) {
        _monthArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _monthArray;
}
- (NSMutableArray *)dayArray
{
    if (!_dayArray) {
        _dayArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dayArray;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WCBillingDateSelectionView" owner:self options:nil] lastObject];
        // 初始化
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIImage *image = [UIImage imageNamed:@"conversion"];
        [self.dateConversionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [window addSubview:self];
        //设置
        [self setConversionButtonTitle:@"按月选择"];
        self.dateBackHeightValue.constant = 300.0f;
        self.dateBackBottomValue.constant = -self.dateBackHeightValue.constant;
        
        self.dateStyle = DateSelectionTypeYearMonth;
        
        // 配置DatePicker
        self.pickView.dataSource = self;
        self.pickView.delegate = self;
        
        self.minimumDate = [WCDataTimeTool dateFromString:@"2000-01-01" DateFormat:@"yyyy-MM-dd"];
        self.maximumDate = [NSDate new];
        self.defaultSelectDate = [NSDate new];
        
        [self updateTextFieldState:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDateView)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}
#pragma mark  ----tool fun----
- (void)setConversionButtonTitle:(NSString *)name
{
    [self.dateConversionButton setTitle:name forState:UIControlStateNormal];
    
    CGFloat imageWidth = self.dateConversionButton.imageView.bounds.size.width+2;
    CGFloat labelWidth = self.dateConversionButton.titleLabel.bounds.size.width+2;
    
    self.dateConversionButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    self.dateConversionButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    self.endDateLineView.backgroundColor = self.endDateTextField.text.length == 0?DISABLED_COLOR:HEIGHT_COLOR;
    
}

/**
 设置时间控件样式
 
 @param style 样式
 */
- (void)setDatePickerViewStyle:(DateSelectionType)style
{
    [self.pickView reloadAllComponents];
    CGFloat constant = 0.0;
    
    NSString *defaultYearStr = [WCDataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"y"];
    NSUInteger yeasRow = [self.yearArray indexOfObject:defaultYearStr];
    
    NSString *defaultMonthStr = [WCDataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"M"];
    NSUInteger monthRow = [self.monthArray indexOfObject:defaultMonthStr];
    
    NSString *defaultDayStr = [WCDataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"d"];
    NSUInteger dayRow = [self.dayArray indexOfObject:defaultDayStr];
    
    
    if (yeasRow < self.yearArray.count) {
        [self.pickView selectRow:yeasRow inComponent:0 animated:YES];
    }
    
    if (monthRow < self.monthArray.count) {
        [self.pickView selectRow:monthRow  inComponent:1 animated:YES];
    }
    
    if (style == DateSelectionTypeYearMonth) {
        
        constant = (mScreenWidth/2+8);
        self.endDateTextField.text = @"";
        self.startDateTextField.text = [NSString stringWithFormat:@"%@-%@",defaultYearStr,defaultMonthStr];
    }
    else
    {
        constant = 0.0f;
        
        if (dayRow < self.dayArray.count) {
            [self.pickView selectRow:dayRow  inComponent:2 animated:YES];
        }
        
        self.startDateTextField.text = [NSString stringWithFormat:@"%@-%@-%@",defaultYearStr,defaultMonthStr,defaultDayStr];
        
    }
    self.zhiCenterXValue.constant = constant;
}

/**
 更新field的赋值状态
 */
- (void)updateTextFieldState:(BOOL)state
{
    self.isStartTextField = state;
    
    UIColor *startColor = state?HEIGHT_COLOR:DISABLED_COLOR;
    UIColor *endColor = state?DISABLED_COLOR:HEIGHT_COLOR;
    self.startDateLineView.backgroundColor = startColor;
    self.endDateLineView.backgroundColor = endColor;
}
#pragma mark  ----时间计算----
//根据传递进入的dayNumber计算dayArray
- (void)setDaysForMonth:(int) dayNumber{
    
    [self.dayArray removeAllObjects];
    for (int index=1; index<=_dayNumber; index++) {
        [_dayArray addObject:[@(index) stringValue]];
    }
}
-(void)initYesArr {
    [self.yearArray removeAllObjects];
    NSString *maxYearStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    NSString *minYearStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"yyyy"];
    int difference = [maxYearStr intValue] - [minYearStr intValue];
    if (difference<0 || difference==0) {
        [self.yearArray addObject:maxYearStr];
        return;
    }
    for (int i = 0; i<=difference; i ++) {
        NSString *yesS = [NSString stringWithFormat:@"%d",[minYearStr intValue] + i];
        [self.yearArray addObject:yesS];
    }
    [self YearMonthEqual_pickerView:self.pickView inComponent:0 month:[self.month intValue] Year:[self.year intValue]];
}

-(void)initDayArr {
    
    [self.dayArray removeAllObjects];
    [self calculateDayWithMonth:[self.month intValue] andYear:[self.year intValue]];
}

-(void)initMonthArr {
    
    [self.monthArray removeAllObjects];
    
    NSString *maxMonthStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"MM"];
    NSString *maxYearStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    
    NSString *minMonthStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"MM"];
    NSString *minYearStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"yyyy"];
    
    if ([maxYearStr intValue] == [minYearStr intValue]) {
        for (int i = [minMonthStr intValue]; i<=[maxMonthStr intValue]; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.monthArray addObject:yesS];
        }
        return;
    }
    [self YearMonthEqual_pickerView:self.pickView inComponent:0 month:[self.month intValue] Year:[self.year intValue]];
}
-(void)YearMonthEqual_pickerView:(UIPickerView *)pickerView inComponent:(NSInteger)component month:(int)month Year:(int) year {
    
    NSString *maxYearStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    NSString *maxMonthStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"MM"];
    NSString *maxDayStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"dd"];
    
    if (component == 0) {
        [self.monthArray removeAllObjects];
        if ([maxYearStr intValue] != year) {
            NSString *minMonthStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"MM"];
            for (int i = [minMonthStr intValue]; i<=12; i++) {
                NSString *yesS = [NSString stringWithFormat:@"%d",i];
                [self.monthArray addObject:yesS];
            }
            [pickerView reloadComponent:1];
        }else {
            for (int i = 1; i<=[maxMonthStr intValue]; i++) {
                NSString *yesS = [NSString stringWithFormat:@"%d",i];
                [self.monthArray addObject:yesS];
            }
            if ([maxMonthStr intValue] < [self.month intValue]) {
                self.month = maxMonthStr;
                month = [maxMonthStr intValue];
            }
            [pickerView reloadComponent:1];
        }
        
        if ([maxYearStr intValue] == month && [maxMonthStr intValue] == year) {
            [self.dayArray removeAllObjects];
            for (int i = 1; i<=[maxDayStr intValue]; i++) {
                NSString *yesS = [NSString stringWithFormat:@"%d",i];
                [self.dayArray addObject:yesS];
            }
            [pickerView reloadComponent:2];
        }
    }
    
}

//根据month和year计算对应的天数
-(void)calculateDayWithMonth:(int) month andYear:(int) year{
    float yearF = [self.year floatValue]/4; //能被4整除的是闰年
    float yearI = (int)yearF; //若yearI和yearF不一样，也就是说没有被整除，则不是闰年
    //当然以上计算没有包括：能被100整除，但不能被400整除的，不是闰年，因为2000年已过2100年还远....
    switch (month) {
        case 1:_dayNumber = 31; break;
        case 2:
            if(yearF != yearI){_dayNumber = 28;}else{
                _dayNumber = 29;}break;
        case 3:_dayNumber = 31;break;
        case 4:_dayNumber = 30;break;
        case 5:_dayNumber = 31;break;
        case 6:_dayNumber = 30;break;
        case 7:_dayNumber = 31;break;
        case 8:_dayNumber = 31;break;
        case 9:_dayNumber = 30;break;
        case 10:_dayNumber = 31;break;
        case 11:_dayNumber = 30;break;
        case 12:_dayNumber = 31;break;
        default:_dayNumber = 31;break;
    }
    
    NSString *maxYearStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"yyyy"];
    NSString *maxMonthStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"MM"];
    NSString *maxDayStr = [WCDataTimeTool stringFromDate:self.maximumDate DateFormat:@"dd"];
    
    NSString *minYearStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"yyyy"];
    NSString *minMonthStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"MM"];
    NSString *minDayStr = [WCDataTimeTool stringFromDate:self.minimumDate DateFormat:@"dd"];
    
    if ([minYearStr intValue] == year && [minMonthStr intValue] == month && [maxYearStr intValue] == year && [maxMonthStr intValue] == month) {
        [self.dayArray removeAllObjects];
        for (int i = [minDayStr intValue]; i<=[maxDayStr intValue]; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:yesS];
        }
        return;
    }
    
    if ([minYearStr intValue] == year && [minMonthStr intValue] == month) {
        [self.dayArray removeAllObjects];
        for (int i = [minDayStr intValue]; i<=_dayNumber; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:yesS];
        }
        return;
    }
    
    if ([maxYearStr intValue] == year && [maxMonthStr intValue] == month) {
        [self.dayArray removeAllObjects];
        for (int i = 1; i<=[maxDayStr intValue]; i++) {
            NSString *yesS = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:yesS];
        }
        return;
    }
    [self setDaysForMonth:_dayNumber]; //此处调用函数，将dayArray重新赋值；
}
#pragma  mark -- <UIPickerViewDataSource,UIPickerViewDelegate>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.dateStyle == DateSelectionTypeYearMonth) {
        return 2;
    }else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.yearArray.count;
    }else if(component==1){
        return self.monthArray.count;
    } else{
        return self.dayArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
    }else if(component==1){
        return [NSString stringWithFormat:@"%@月",[self.monthArray objectAtIndex:row]];
    }else {
        return [NSString stringWithFormat:@"%@日",[self.dayArray objectAtIndex:row]];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        _dayShouldChangeEnable = true;
        self.year = self.yearArray[row];
        self.selectedRowYear = (int)row;
        [pickerView reloadComponent:0];
        [self YearMonthEqual_pickerView:pickerView inComponent:0 month:[self.month intValue] Year:[self.year intValue]];
    }else if(component==1){
        _dayShouldChangeEnable = true;
        self.month = self.monthArray[row];
        self.selectedRowMonth = (int)row;
        [pickerView reloadComponent:1];
        [self YearMonthEqual_pickerView:pickerView inComponent:1 month:[self.month intValue] Year:[self.year intValue]];
    }else{
        self.day = _dayArray[row];
        self.selectedRowDay = (int)row;
        [pickerView reloadComponent:2];
    }
    if (self.dateStyle == DataPickViewTypeYearMonthDay) {
        if(_dayShouldChangeEnable){
            //调用计算天数的函数
            [self calculateDayWithMonth:[self.month intValue] andYear:[self.year intValue]];
            //由于更新的时候self.selectRowDay很可能大于 天数的最大值，比如self.selectRowDay为31，而天数最大值切换至了29，所以若超出，则需要将selectRowDay重新赋值
            if(self.selectedRowDay > _dayNumber-1){
                self.selectedRowDay = _dayNumber-1;
            }
            [pickerView reloadComponent:2];
            _dayShouldChangeEnable = false;
        }
    }
    if ([self.delegate respondsToSelector:@selector(pickViewScroollCallBack_year:month:day:)]) {
        [self.delegate pickViewScroollCallBack_year:self.year month:self.month day:self.day];
    }
    
    [self startCallBack];
    
}
- (void)startCallBack{
    
    NSInteger yearRow = [self.pickView selectedRowInComponent:0];
    NSInteger monthRow = [self.pickView selectedRowInComponent:1];
    NSString *dateString;
    
    if (self.dateStyle == DateSelectionTypeYearMonth) {
        
        dateString = [NSString stringWithFormat:@"%@-%@",[self.yearArray objectAtIndex:yearRow],[self.monthArray objectAtIndex:monthRow]];
    }
    if (self.dateStyle == DataPickViewTypeYearMonthDay) {
        NSInteger dayRow = [self.pickView selectedRowInComponent:2];
        
        dateString = [NSString stringWithFormat:@"%@-%@-%@",[self.yearArray objectAtIndex:yearRow],[self.monthArray objectAtIndex:monthRow],[self.dayArray objectAtIndex:dayRow]];
    }

    if (self.isStartTextField) {
        
        self.startDateTextField.text = dateString;
    }
    else
    {
        self.endDateTextField.text = dateString;
    }
}

#pragma mark  ----按钮点击事件----
- (IBAction)conversionClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.dateStyle = sender.selected?DateSelectionTypeYearMonth:DataPickViewTypeYearMonthDay;
    [self setDatePickerViewStyle:self.dateStyle];
    [self setConversionButtonTitle:sender.selected?@"按月选择":@"按日选择"];
}
- (IBAction)hiddenClick:(UIButton *)sender {
    [self hideDateView];
}
- (IBAction)startDateButtonClick:(UIButton *)sender {
    [self updateTextFieldState:YES];
}
- (IBAction)endDateButtonClick:(UIButton *)sender {
    [self updateTextFieldState:NO];
}
- (IBAction)determineButtonClick:(UIButton *)sender {
    
    NSString *startTime = self.startDateTextField.text;
    NSString *endTime = self.endDateTextField.text;
    
    if (self.dateStyle == DateSelectionTypeYearMonth) {
        
        NSArray *dataArry = [WCDataTimeTool getMonthFirstAndLastDayWith:startTime];
        startTime = dataArry.firstObject;
        endTime = dataArry.lastObject;
        
    }
    if (startTime.length == 0) {
        
        [UIView addMJNotifierWithText:@"请选择开始时间" dismissAutomatically:YES];
        return;
    }
    
    if (endTime.length == 0) {
        [UIView addMJNotifierWithText:@"请选择结束时间" dismissAutomatically:YES];
        return;
        
    }
    if (![WCDataTimeTool compareStartDay:startTime withendDay:endTime]) {
        
        NSString *zh = startTime;
        startTime = endTime;
        endTime = zh;
    }
    
    if ([self.delegate respondsToSelector:@selector(pickViewCallBackStartTime:toEndTime:timeType:)]) {
        [self.delegate pickViewCallBackStartTime:startTime toEndTime:endTime timeType:self.dateStyle];
    }
    [self hideDateView];
}
#pragma mark  ----显示和隐藏事件----
- (void)showDateView;
{
    self.month = [WCDataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"MM"];
    self.year = [WCDataTimeTool stringFromDate:self.defaultSelectDate DateFormat:@"yyyy"];
    [self initYesArr];
    [self initMonthArr];
    [self initDayArr];
    
    [self setDatePickerViewStyle:self.dateStyle];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.dateBackBottomValue.constant = 0.0f;
        [self layoutIfNeeded];
        
    } completion:nil];
}
- (void)hideDateView {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.dateBackBottomValue.constant = -self.dateBackHeightValue.constant;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
