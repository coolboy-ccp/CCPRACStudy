//
//  ViewController.m
//  CCPRACStudy
//
//  Created by 储诚鹏 on 17/2/27.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "ViewController.h"
#import "ColorsViewController.h"
@import ReactiveObjC;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal *signal = [[RACSignal combineLatest:@[self.userName.rac_textSignal,self.passWord.rac_textSignal]] map:^id _Nullable(id  _Nullable value) {
        return @([value[0] length] > 0 && [value[1] length] >= 6);
    }];
    self.loginBtn.rac_command = [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"touchupinside");
            //此处可以很好的对延时操作进行控制，不会出现btn重复点击
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[[NSDate date] description]];
                [subscriber sendCompleted];
                ColorsViewController *color = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"ColorsViewController"];
                [self presentViewController:color animated:YES completion:nil];
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    [[[self.loginBtn rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"x");
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
