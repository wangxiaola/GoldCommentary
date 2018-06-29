//
//  WCBusinessDateSelectionView.m
//  channelTool
//
//  Created by 王小腊 on 2018/6/20.
//  Copyright © 2018年 王小腊. All rights reserved.
//


#import "WCBusinessDateSelectionView.h"
#import "WCPublic.h"
@interface WCBusinessDateSelectionView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *stateTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
@property (weak, nonatomic) IBOutlet UIView *stateLinView;
@property (weak, nonatomic) IBOutlet UIView *endLinView;
@property (weak, nonatomic) IBOutlet UIButton *allTimeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeight;

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) NSArray *hoursArray;//小时
@property (nonatomic, strong) NSArray *minutesArray;//分钟

@property (nonatomic, assign) BOOL isSelectStart; //是否是开始
@end

@implementation WCBusinessDateSelectionView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WCBusinessDateSelectionView" owner:self options:nil] lastObject];
        // 初始化
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [window addSubview:self];
    
        
        self.viewHeight = _SCREEN_HEIGHT/2-10;
        self.baseViewHeight.constant = self.viewHeight;
        self.viewBottomConstraint.constant = -self.viewHeight;
        self.hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
        self.minutesArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
        
        self.isSelectStart = YES;
        self.stateLinView.backgroundColor = NAVIGATION_COLOR;
        self.endLinView.backgroundColor = [UIColor colorWithRed:223/255.0 green:224/255.0 blue:225/255.0 alpha:1];
        
        self.allTimeButton.layer.cornerRadius = 4;
        
        self.stateTimeField.text = @"09:00";
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:8 inComponent:0 animated:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDateView)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}
#pragma  mark -- <UIPickerViewDataSource,UIPickerViewDelegate>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
    {
        return self.hoursArray.count;
    }
    return self.minutesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@时",[self.hoursArray objectAtIndex:row]];
    }
     return [NSString stringWithFormat:@"%@分",[self.minutesArray objectAtIndex:row]];
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

    [self startCallBack];
}
#pragma mark  ----fun tool----
- (void)startCallBack
{
    NSInteger hoursRow = [self.pickerView selectedRowInComponent:0];
    NSInteger minutesRow = [self.pickerView selectedRowInComponent:1];
    NSString *hours = self.hoursArray[hoursRow];
    NSString *minutes = self.minutesArray[minutesRow];
    
    if (self.isSelectStart) {
        self.stateTimeField.text = [NSString stringWithFormat:@"%@:%@",hours,minutes];
    }
    else
    {
        self.endTimeField.text = [NSString stringWithFormat:@"%@:%@",hours,minutes];
    }
}
- (void)hideDateView
{
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.viewBottomConstraint.constant = -self.viewHeight;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showDateView;
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.viewBottomConstraint.constant = 0.0f;
        [self layoutIfNeeded];
        
    } completion:nil];
}
#pragma mark  ----点击事件----
- (IBAction)stateTimeClick:(UIButton *)sender {
    
    self.isSelectStart = YES;
    self.stateLinView.backgroundColor = NAVIGATION_COLOR;
    self.endLinView.backgroundColor = [UIColor colorWithRed:223/255.0 green:224/255.0 blue:225/255.0 alpha:1];
}
- (IBAction)endTimeClick:(UIButton *)sender {
    self.isSelectStart = NO;
    self.endLinView.backgroundColor = NAVIGATION_COLOR;
    self.stateLinView.backgroundColor = [UIColor colorWithRed:223/255.0 green:224/255.0 blue:225/255.0 alpha:1];
}

- (IBAction)hiddenClick:(UIButton *)sender {
    [self hideDateView];
}
- (IBAction)allTime:(UIButton *)sender {
    
    if (self.businessTime) {
        self.businessTime(@"00:00",@"23:59");
    }
    [self hideDateView];
}
- (IBAction)senderClick:(UIButton *)sender {
    
    if (self.stateTimeField.text.length == 0) {
        
        [UIView addMJNotifierWithText:@"请选择开放时间" dismissAutomatically:YES];
        return;
    }
    if (self.endTimeField.text.length == 0) {
        [UIView addMJNotifierWithText:@"请选择结束时间" dismissAutomatically:YES];
        return;
    }
    
    if (self.businessTime) {
        
        CGFloat hours = [self.stateTimeField.text stringByReplacingOccurrencesOfString:@":" withString:@""].floatValue;
        CGFloat minutes = [self.endTimeField.text stringByReplacingOccurrencesOfString:@":" withString:@""].floatValue;
        BOOL isMax = hours < minutes;
        // 比较大小
        if (isMax) {
        
           self.businessTime(self.stateTimeField.text,self.endTimeField.text);
        }
        else
        {
           self.businessTime(self.endTimeField.text,self.stateTimeField.text);
        }
    }
    
    [self hideDateView];
}

@end
