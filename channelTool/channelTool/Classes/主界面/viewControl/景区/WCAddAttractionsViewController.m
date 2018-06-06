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
#import "WCUploadPromptView.h"
#import <IQKeyboardManager/IQTextView.h>
@interface WCAddAttractionsViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@property (weak, nonatomic) IBOutlet UITextField *scenicNameField;

@property (weak, nonatomic) IBOutlet IQTextView *infoTextView;//简介

@property (weak, nonatomic) IBOutlet UITextField *visitTimeField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet UIStepper* stepper;

@property (weak, nonatomic) IBOutlet UIButton *recommendedButton;

@property (nonatomic, strong) TBChoosePhotosTool * tool;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

@property (strong, nonatomic) NSMutableArray *imageArray;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
@property (assign, nonatomic) CGFloat  cellWidth;

@property (assign, nonatomic) NSInteger recommendedNumber;//推荐
@end

@implementation WCAddAttractionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"创建景点";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setUpView];
    
    if (self.scenicMode.ID.length > 0) {
        
        [self updateScenicData];
    }
}
#pragma mark ---初始化视图----
- (void)setUpView
{
    self.infoTextView.delegate = self;
    
    self.stepper.continuous = true;
    self.stepper.autorepeat = true;
    self.stepper.minimumValue = 1;
    
    [self.stepper setValue:self.scenicMode.rows];
    self.numberField.text = [NSString stringWithFormat:@"%g",self.stepper.value];
    
    self.tool = [[TBChoosePhotosTool alloc] init];
    self.tool.delegate = self;
    self.cellWidth = (_SCREEN_WIDTH- 10*8)/3;
    
    self.maxRow = 3;
    self.recommendedNumber = 1;
    
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

/**
 更新推荐按钮的状态

 @param state 1推荐
 */
- (void)updateRecommendedButtonState:(NSInteger)state
{
    NSString *image = state == 0?@"foregroundStar":@"backgroundStar";
    [self.recommendedButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    self.recommendedNumber = state;
}
#pragma mark  ----数据上传----
// 更新景点数据
- (void)updateScenicData
{
    self.scenicNameField.text = self.scenicMode.name;
    [self.imageArray addObjectsFromArray:[self.scenicMode.allimg componentsSeparatedByString:@","]];
    [self updataCollectionView];
    
    self.infoTextView.text = self.scenicMode.info;
    [self textViewDidChange:self.infoTextView];
    
    self.visitTimeField.text = self.scenicMode.routetime;
    self.numberField.text = self.scenicMode.sort;
    [self.stepper setValue:self.scenicMode.sort.doubleValue];
    [self updateRecommendedButtonState:self.scenicMode.hotLevel.integerValue];
}
// 上传图片
- (void)uploadPictures
{
    
    hudShopWUploadProgress(0.1, @"正在上传图片");
    
    dispatch_group_t group = dispatch_group_create();
    TBWeakSelf
    for (int i = 0; i<self.imageArray.count; i++) {
        dispatch_group_enter(group);
        id data = self.imageArray[i];
        if ([data isKindOfClass:[UIImage class]]) {
            
            [ZKPostHttp uploadImage:POST_URL Data:UIImageJPEGRepresentation(data, 0.5) success:^(id  _Nonnull responseObj) {
                
                if ([[responseObj valueForKey:@"errcode"] isEqualToString:@"00000"]) {
                    
                    NSDictionary *data = [responseObj valueForKey:@"data"];
                    NSString *url = [data valueForKey:@"url"];
                    hudShopWUploadProgress(0.2*i, @"正在上传图片");
                    [weakSelf.imageArray replaceObjectAtIndex:i withObject:url];
                }
                dispatch_group_leave(group);
                
            } failure:^(NSError * _Nonnull error) {
                
                dispatch_group_leave(group);
            }];
        }
        else
        {
            dispatch_group_leave(group);
            hudShopWUploadProgress(0.2*i, @"正在上传图片");
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if ([weakSelf.imageArray containsObject:[UIImage class]]) {
            
            hudShowError(@"景区图片上传遗漏");
        }
        else
        {
            weakSelf.scenicMode.allimg = [weakSelf.imageArray componentsJoinedByString:@","];
            [weakSelf submitScenicData];
        }
    });
    
    
}
// 提交数据
- (void)submitScenicData
{
    NSString *shopid = self.scenicMode.scenicID?self.scenicMode.scenicID:@"";
    NSString *spotid = self.scenicMode.ID?self.scenicMode.ID:@"";
    NSString *hotLevel = [NSString stringWithFormat:@"%ld",self.recommendedNumber];
    
    NSString *routetime = self.visitTimeField.text? :@"";
    
    NSDictionary *dic = @{@"interfaceId":@"308",
                          @"id":[UserInfo account].userID,
                          @"shopid":shopid,
                          @"spotid":spotid,
                          @"name":self.scenicNameField.text,
                          @"info":self.infoTextView.text,
                          @"basicVoc":@"0000",
                          @"routetime":routetime,
                          @"hotLevel":hotLevel,
                          @"sort":self.numberField.text,
                          @"psort":self.scenicMode.psort,
                          @"pname":self.scenicMode.pname,
                          @"pinfo":self.scenicMode.scenicInfo,
                           @"allimg":[self.imageArray componentsJoinedByString:@","],
                          };
    
    hudShopWUploadProgress(0.8, @"正在上传图片");
    TBWeakSelf
    [[ZKPostHttp shareInstance] POST:POST_URL params:dic success:^(id  _Nonnull responseObject) {
        
        if ([[responseObject valueForKey:@"errcode"] isEqualToString:@"00000"]) {
            
            NSString *spotid = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"data"]];
            weakSelf.scenicMode = [WCAddScenicImageMode mj_objectWithKeyValues:dic];
            weakSelf.scenicMode.ID = spotid;
            
            [WCUploadPromptView showPromptString:self.scenicMode.ID?@"景点更新成功":@"景点创建成功" isSuccessful:NO clickButton:^{
                
                if (weakSelf.refreshTableView) {
                    weakSelf.refreshTableView(weakSelf.scenicMode);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [WCUploadPromptView showPromptString:[responseObject valueForKey:@"errmsg"] isSuccessful:NO clickButton:^{
            }];
        }
        hudDismiss();
        
    } failure:^(NSError * _Nonnull error) {
        
        hudShowError(@"网络异常，请查看网络连接");
        
    }];
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
        [self shakeAnimationForView:self.infoTextView.superview markString:@"请填写简介"];
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
    [self uploadPictures];
}
- (IBAction)recommendedClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self updateRecommendedButtonState:sender.selected];
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
    
    if (newSize.height > 120)
    {
        self.infoViewHeight.constant = 120.0f;
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
    
    NSInteger rows = self.imageArray.count >3?3:self.imageArray.count;
    return rows;
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

- (IBAction)recommendedButton:(UIButton *)sender {
}
@end
