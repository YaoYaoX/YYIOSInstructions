//
//  YYAuthorityCell.m
//  YYIOSInstructions
//
//  Created by YaoYaoX on 17/5/12.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "YYAuthorityCell.h"
#import "YYAuthorityModel.h"

@interface YYAuthorityCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UIButton *authorityBtn;

@end

@implementation YYAuthorityCell

- (void)setModel:(YYAuthorityModel *)model {
    _model = model;
    self.nameLbl.text = [YYAuthorityModel titleWithType:model.type];
    self.detailLbl.text = model.detail;
    self.authorityBtn.hidden = !model.needAuthorize;
}

- (IBAction)authorize:(UIButton *)sender {
    if (self.authorizeBlock) {
        self.authorizeBlock(self.model);
    }
}

@end
