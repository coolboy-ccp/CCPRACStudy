//
//  ColorsViewController.m
//  CCPRACStudy
//
//  Created by 储诚鹏 on 17/2/27.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "ColorsViewController.h"
@import ReactiveObjC;

@interface ColorsViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *redTF;
@property (weak, nonatomic) IBOutlet UITextField *greenTF;
@property (weak, nonatomic) IBOutlet UITextField *blueTF;

@end

@implementation ColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greenTF.text = self.redTF.text = self.blueTF.text = @"0.5";
    RACSignal *redSignal = [self boundSlider:self.redSlider textfield:self.redTF];
    RACSignal *greenSignal = [self boundSlider:self.greenSlider textfield:self.greenTF];
    RACSignal *blueSignal = [self boundSlider:self.blueSlider textfield:self.blueTF];
   /* [[[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id _Nullable(RACTuple *  _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }] subscribeNext:^(id  _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = x;
        });
    }];
    */
    RACSignal *newSignal = [[RACSignal combineLatest:@[redSignal, greenSignal, blueSignal]] map:^id _Nullable(RACTuple *  _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1.0];
    }];
    RAC(self.view, backgroundColor) = newSignal;
}


- (RACSignal *)boundSlider:(UISlider *)slider textfield:(UITextField *)tf {
    RACSignal *textSignal = [tf.rac_textSignal take:1];
    RACChannelTerminal *sliderTerminal = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *textTerminal = [tf rac_newTextChannel];
    [[sliderTerminal map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
    }] subscribe:textTerminal];
    [textTerminal subscribe:sliderTerminal];
    return [[sliderTerminal merge:textTerminal] merge:textSignal];
}


@end
