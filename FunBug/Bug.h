//
//  Bug.h
//  FunBug
//
//  Created by liuwei on 12-12-5.
//  Copyright (c) 2012年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface Bug : UIImageView

@property (assign, nonatomic) UIView *superView;
@property CGPoint startPoint;
@property CGPoint endPoint;
@property BOOL dead;

- (id)initWithSuperView:(UIView *)superView;

- (void) turnTo;
- (void) moveTo;
- (void) turnBack;
- (void) moveBack;

@end
