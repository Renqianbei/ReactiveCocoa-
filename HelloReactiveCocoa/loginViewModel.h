//
//  loginViewModel.h
//  HelloReactiveCocoa
//
//  Created by 任前辈 on 2018/1/11.
//  Copyright © 2018年 任前辈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface Account:NSObject
@property (nonatomic, copy)NSString * account;
@property (nonatomic, copy)NSString * pwd;

@end

@interface loginViewModel : NSObject


@property (nonatomic, strong)Account*user;

//是否能够登录的信号
@property (nonatomic, strong,readonly)RACSignal*loginEnabledSingle;

@property (nonatomic, strong,readonly)RACCommand* loginComand;

@property (nonatomic, strong,readonly)RACCommand* login2Comand;



@end

