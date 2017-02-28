//
//  CreateASignal.m
//  CCPRACStudy
//
//  Created by 储诚鹏 on 17/2/28.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "CreateASignal.h"
@import ReactiveObjC;

@implementation CreateASignal

//http://www.orzer.club/test.json

- (void)request {
    [[self signalFromJson:@"http://www.orzer.club/test.json"] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    RACSignal *s1;
    RACSignal *s2;
    RACSignal *s3;
    //并发请求
    [[RACSignal combineLatest:@[s1,s2,s3]] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
}


- (RACSignal *)signalFromJson:(NSString *)str {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionConfiguration *c = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:c];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:str] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                NSError *e;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                if (e) {
                    [subscriber sendError:e];
                }
                else {
                    [subscriber sendNext:jsonDic];
                    [subscriber sendCompleted];
                }
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

//高级函数
//pull driven :RACSignal
//side effect 副作用
- (void)sideEffect {
    __block int a = 10;
    RACSignal *s = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    //打印结果为15
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //打印结果为20
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //避免副作用
    RACSignal *s1 = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] replayLast];
    //打印结果为15
    [s1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //打印结果为15
    [s1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //push driven :RACSequence
    RACSequence *queue = [s sequence];
    
    NSArray *arr = @[@0,@1];
    queue = [arr rac_sequence];
    arr = [queue array];
    
    //map,flatMap,filter,reduce（包装成元祖的反向操作)类似于swift中的高级函数
    //concat 连接
    RACSignal *s2;
    RACSignal *s3;
    [[s2 concat:s3] subscribeNext:^(id  _Nullable x) {
        //x 是一个元祖，包含s2,s3
        //先执行s2，再执行s3
    }];
    //
    [[s2 then:^RACSignal * _Nonnull{
        return s3;
    }] subscribeNext:^(id  _Nullable x) {
      //先执行s2，再执行s3
      //x里面只包s3参数
    }];
    
}



@end
