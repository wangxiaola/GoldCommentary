//
//  WCCreateScenicViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/15.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCCreateScenicViewController.h"
#import "TBMoreReminderView.h"
#import "TBTemplateResourceCollectionViewCell.h"
#import "TBChoosePhotosTool.h"
#import "YBPopupMenu.h"
#import "WSDatePickerView.h"
#import "UIButton+ImageTitleStyle.h"
#import <IQKeyboardManager/IQTextView.h>

@interface WCCreateScenicViewController ()<UITextViewDelegate,YBPopupMenuDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scenicNameField;
@property (weak, nonatomic) IBOutlet UITextField *adderssField;
@property (weak, nonatomic) IBOutlet UITextField *ticketsField;
@property (weak, nonatomic) IBOutlet IQTextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITextField *visitingTimeField;
@property (weak, nonatomic) IBOutlet UITextField *headNameField;
@property (weak, nonatomic) IBOutlet UITextField *headPhoneField;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@property (nonatomic, strong) TBChoosePhotosTool * tool;
@property (assign, nonatomic) CGFloat  cellWidth;
@property (strong, nonatomic) NSMutableArray *imageArray;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
@end

@implementation WCCreateScenicViewController
//视图将要出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"创建景区";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setUpView];
    
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    self.infoTextView.scrollEnabled = NO;
    self.infoTextView.delegate = self;
    
    self.levelButton.layer.cornerRadius = 4;
    self.levelButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.levelButton.layer.borderWidth = 0.6;
    [self.levelButton setButtonImageTitleStyle:(ButtonImageTitleStyleRightLeft) padding:4];
    
    self.headPhoneField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.startButton.layer.cornerRadius = 4;
    self.startButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.startButton.layer.borderWidth = 0.6;
    self.startButton.tag = 1000;
    
    self.endButton.layer.cornerRadius = 4;
    self.endButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.endButton.layer.borderWidth = 0.6;
    self.endButton.tag = 1001;
    
    self.tool = [[TBChoosePhotosTool alloc] init];
    self.tool.delegate = self;
    self.cellWidth = (_SCREEN_WIDTH- 10*8)/3;
    
    self.maxRow = 3;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 9;
    flowlayout.minimumLineSpacing = 9;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.bounces = NO;
    self.photoCollectionView.scrollEnabled = NO;
    [self.photoCollectionView registerClass:[TBTemplateResourceCollectionViewCell class] forCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID];
    self.photoCollectionView.collectionViewLayout = flowlayout;
    
}
- (IBAction)selectPhotos:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.imageArray.count == self.maxRow) {
      
        [UIView addMJNotifierWithText:@"请先删除一些照片" dismissAutomatically:YES];
        return;
    }
    [self.tool showPhotosIndex:self.maxRow-self.imageArray.count];
}
- (IBAction)selectLevel:(UIButton *)sender {
    
    [self.view endEditing:YES];

    YBPopupMenu *popupMenu = [YBPopupMenu showRelyOnView:sender titles:@[@"5A",@"4A",@"3A",@"其它星级"] icons:nil menuWidth:100 delegate:self];
    popupMenu.offset = 5;
    popupMenu.fontSize = 13;
    popupMenu.type = YBPopupMenuTypeDefault;
    
}
- (IBAction)goMapView:(UIButton *)sender {
    [self.view endEditing:YES];
}
- (IBAction)selectTime:(UIButton *)sender {
    [self.view endEditing:YES];

    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSString *date = [selectDate stringWithFormat:@"HH:mm"];
        [sender setTitle:date forState:UIControlStateNormal];
        
    }];
    datepicker.doneButtonColor = NAVIGATION_COLOR;
    datepicker.dateLabelColor = NAVIGATION_COLOR;
    [datepicker show];
}
#pragma mark  ----UITextViewDelegate----
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    // 重新计算高度
    if (newSize.height > 24) {
        self.infoViewHeight.constant = newSize.height;
    }
}
#pragma mark  ----YBPopupMenuDelegate----
/**
 点击事件回调
 */
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu;
{
    /*** 字段赋值 ***/
 
    NSString *levelName = @"其它星级   ";
    if (index < 3) {
        
        levelName = [NSString stringWithFormat:@"%ldA",5-index];
    }
    [self.levelButton setTitle:levelName forState:UIControlStateNormal];
    [self.levelButton setButtonImageTitleStyle:(ButtonImageTitleStyleRightLeft) padding:4];
}
#pragma mark <UICollectionViewDataSource>
- (void)updataCollectionView;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updataCollectionViewHeight];
        [self.photoCollectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

     return self.imageArray.count;
}
- (TBTemplateResourceCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TBTemplateResourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID forIndexPath:indexPath];
    
     [cell valueCellImage:self.imageArray[indexPath.row] showDelete:YES index:indexPath.row];
    TBWeakSelf
    [cell setDeleteCell:^(NSInteger row)
     {
         [weakSelf friendlyPromptIndex:row];
         
     }];
    return cell;
}
// 提示
- (void)friendlyPromptIndex:(NSInteger)dex
{
    [self.view endEditing:YES];
    
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否删除当前图片?"];
    [more showHandler:^{
        [weakSelf.imageArray removeObjectAtIndex:dex];
        [weakSelf.photoCollectionView reloadData];
        [weakSelf updataCollectionView];
    }];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    
    TBTemplateResourceCollectionViewCell *cell = (TBTemplateResourceCollectionViewCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    
    [self.tool showPreviewPhotosArray:self.imageArray baseView:cell.backImageView selected:indexPath.row];
}

#pragma mark ---- TBChoosePhotosToolDelegate --

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.imageArray addObjectsFromArray:images];
        [weakSelf updataCollectionView];
    });
    
}

/**
 计算cell高度
 */
- (void)updataCollectionViewHeight
{
    CGFloat  constant  = 0.01f;
    if (self.imageArray.count > 0) {
        constant  = 20+self.cellWidth;
    }
    self.photoCollectionHeight.constant = constant;
    
}
#pragma mark  ----懒加载----
- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
