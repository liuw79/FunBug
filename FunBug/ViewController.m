//
//  ViewController.m
//  FunBug
//
//  Created by liuwei on 12-12-2.
//  Copyright (c) 2012年 liuwei. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SettingViewViewController.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet UIImageView *doorTop;
@property (retain, nonatomic) IBOutlet UIImageView *doorBottom;
@property (retain, nonatomic) IBOutlet UIImageView *tissueTop;
@property (retain, nonatomic) IBOutlet UIImageView *tissueButtom;
@property (retain, nonatomic) IBOutlet UIImageView *plate;
@property (retain, nonatomic) NSDictionary *dic;

@property CGPoint *bugOrigionPosition;
@property CGPoint *bugTargetPosition;

- (IBAction)setSettings:(id)sender;
- (void)addBug;

@end

@implementation ViewController

-(void)setSettings:(id)sender
{
    SettingViewViewController *settingController = [[SettingViewViewController alloc] initWithNibName:@"SettingViewViewController" bundle:nil];
    
    [self presentViewController:settingController animated:YES completion:nil];
    
    [settingController release];
    
    settingController = nil;
}

- (void)bePressed:(Bug *)bug
{
    [bug removeFromSuperview];
    bug = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear.");
    self.dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dicSettings"];
    
    CGRect topFrame = self.doorTop.frame;
    topFrame.origin.y = -self.doorTop.frame.size.height;
    
    CGRect bottomFrame = self.doorBottom.frame;
    bottomFrame.origin.y += self.doorBottom.frame.origin.y;
    
    CGRect topTissueFrame = self.tissueTop.frame;
    topTissueFrame.origin.y = -self.tissueTop.frame.size.height;
    
    CGRect bottomTissueFrame = self.tissueButtom.frame;
    bottomTissueFrame.origin.y += self.tissueButtom.frame.origin.y;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.doorTop setFrame:topFrame];
                         [self.doorBottom setFrame:bottomFrame];
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.tissueTop setFrame:topTissueFrame];
                         [self.tissueButtom setFrame:bottomTissueFrame];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 1; i <= arc4random() % 10; i++) {
        [self addBug];
    }

}

- (void)addBug
{
    Bug *bug = [[Bug alloc] initWithSuperView:self.view];
    [self.view addSubview:bug];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_doorTop release];
    [_doorBottom release];
    [_tissueTop release];
    [_tissueButtom release];
    [_plate release];
    [super dealloc];
}
@end
