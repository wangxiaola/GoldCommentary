//
//  WCAttributeTouchLabel.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/30.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCAttributeTouchLabel.h"
#import <Masonry/Masonry.h>

@interface WCAttributeTouchLabel ()<UITextViewDelegate>


@end
@implementation WCAttributeTouchLabel
{
    UITextView *_textView;
}
- (instancetype)init{
    
    if (self = [super init]) {
        
        
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.editable = NO;//必须禁止输入，否则点击将会弹出输入键盘
        _textView.scrollEnabled = NO;//可选的，视具体情况而定
        [self addSubview:_textView];
        
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
    
}
- (void)setContenString:(NSString *)str clickString:(NSString *)clickString
{
    NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
    muParagraph.lineSpacing = 6;// 行距
    muParagraph.paragraphSpacing = 8; // 段距
    muParagraph.firstLineHeadIndent = 20; // 首行缩进

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range = [str rangeOfString:clickString options:NSBackwardsSearch];
    
    [attStr addAttribute:NSLinkAttributeName value:@"click://" range:range];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} range:NSMakeRange(0, str.length)];
    // 设置段落样式
    [attStr addAttribute:NSParagraphStyleAttributeName value:muParagraph range:NSMakeRange(0, str.length)];
    _textView.attributedText = attStr;
    
}
#pragma mark  ----UITextViewDelegate----
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([[URL scheme] isEqualToString:@"click"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        if (self.eventBlock) {
            self.eventBlock([abStr string]);
        }
        
        return NO;
    }
    
    return YES;
}
@end
