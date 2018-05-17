//
//  WCAddAttractionsViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAddAttractionsViewController.h"
#import "TBMoreReminderView.h"
#import "TBTemplateResourceCollectionViewCell.h"
#import "TBChoosePhotosTool.h"
#import "WCAddScenicMode.h"
#import "TQStarRatingView.h"
#import <IQKeyboardManager/IQTextView.h>
@interface WCAddAttractionsViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scenicNameField;

@property (weak, nonatomic) IBOutlet IQTextView *infoTextView;//简介

@property (weak, nonatomic) IBOutlet UITextField *visitTimeField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet TQStarRatingView *ratingView;

@property (weak, nonatomic) IBOutlet UIStepper* stepper;

@property (nonatomic, strong) TBChoosePhotosTool * tool;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@property (strong, nonatomic) NSMutableArray *imageArray;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
@property (assign, nonatomic) CGFloat  cellWidth;

@end

@implementation WCAddAttractionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"创建景点";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setUpView];
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    self.infoTextView.scrollEnabled = NO;
    self.infoTextView.delegate = self;
    
    self.stepper.continuous = true;
    self.stepper.autorepeat = true;
    self.stepper.minimumValue = 1;
    
    [self.stepper setValue:self.scenicMode.scenicArray.count+1];
    self.numberField.text = [NSString stringWithFormat:@"%g",self.stepper.value];
    
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
- (void)setScenicMode:(WCAddScenicMode *)scenicMode
{
    _scenicMode = scenicMode;
    
}
/**
 添加震动动画
 
 @param view 要动画的视图
 @param mark 提示
 */
- (void)shakeAnimationForView:(UIView *)view markString:(NSString *)mark
{
    if (view) {
        [ZKUtil shakeAnimationForView:view];
    }
    if (mark) {
        [UIView addMJNotifierWithText:mark dismissAutomatically:YES];
    }
}
#pragma mark  ----数据上传----
- (void)postScenicData
{
    
    [[ZKPostHttp shareInstance] POST:@"" params:@{} success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    //    if (self.refreshTableView) {
    //        self.refreshTableView();
    //    }
}
#pragma mark  ----点击事件----
- (IBAction)selectPhoto:(UIButton *)sender {
    
    if (self.imageArray.count == self.maxRow) {
        
        [UIView addMJNotifierWithText:@"请先删除一些照片" dismissAutomatically:YES];
        return;
    }
    [self.tool showPhotosIndex:self.maxRow-self.imageArray.count];
    
}
- (IBAction)scenicRecording:(UIButton *)sender {
    
    
}
- (IBAction)valueChanged:(UIStepper *)sender {
    
    self.numberField.text = [NSString stringWithFormat:@"%g",sender.value];
}
- (IBAction)updataAttractions:(id)sender {
    
    if (self.imageArray.count == 0) {
        
        [self shakeAnimationForView:self.scenicNameField.superview markString:@"请至少上传一张图片"];
        return;
    }
    
    if (self.scenicNameField.text.length == 0) {
        [self shakeAnimationForView:self.scenicNameField.superview markString:@"请填写景区名称"];
        return;
    }
    if (self.infoTextView.text.length == 0) {
        [self shakeAnimationForView:self.infoTextView.superview markString:@"请填简介"];
        return;
    }
    if (self.visitTimeField.text.length == 0) {
        [self shakeAnimationForView:self.visitTimeField.superview markString:@"请填写游览时长"];
        return;
    }
    
    if (self.numberField.text.integerValue == 0) {
        
        [self shakeAnimationForView:self.numberField.superview markString:@"排序必须大于0"];
        return;
    }
    [self postScenicData];
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
