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
@property (retain, nonatomic) IBOutlet UIImageView *bug;
@property (retain, nonatomic) IBOutlet UIImageView *plate;
@property (retain, nonatomic) NSDictionary *dic;

@property CGPoint *bugOrigionPosition;
@property CGPoint *bugTargetPosition;

- (void)turnRight;
- (void)moveRight;
- (void)turnLeft;
- (void)moveLeft;

- (IBAction)setSettings:(id)sender;

@end

@implementation ViewController

bool bugDead;

-(void)setSettings:(id)sender
{
    SettingViewViewController *settingController = [[SettingViewViewController alloc] initWithNibName:@"SettingViewViewController" bundle:nil];
    
    [self presentViewController:settingController animated:YES completion:nil];
    
    [settingController release];
    
    settingController = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    CGRect bugFrame = [[[self.bug layer] presentationLayer] frame];
    
    if (CGRectContainsPoint(bugFrame, touchPoint)) {
        bugDead = YES;
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"beetle_dead" ofType:@"mp3"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        SystemSoundID soundID;
        OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &soundID);
        if (err) {
            NSLog(@"sound err");
            return;
        }
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, SoundFinished, nil);
        AudioServicesPlaySystemSound(soundID);
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:(UIViewAnimationCurveEaseOut)
                         animations:^{
                             [self.bug setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [self.bug release];
                             self.bug = nil;
                         }];
    }
}

/*****************当音频播放完毕调用这个函数释放资源，避免内存泄露*******************/
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)turnRight
{
    if (bugDead) {
        return;
    }
    
    [UIView animateWithDuration:0.5
                          delay:1.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveRight)];
                         self.bug.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

- (void)moveRight
{
    if (bugDead) {
        return;
    }
    
    
    CGRect rightFrame = CGRectMake([[self.dic objectForKey:@"rightX"] floatValue],
                                   [[self.dic objectForKey:@"rightY"] floatValue], 84, 86);
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(turnLeft)];
                         [self.bug setFrame:rightFrame];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

- (void)turnLeft
{
    if (bugDead) {
        return;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveLeft)];
                         self.bug.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

-(void)moveLeft
{
    if (bugDead) {
        return;
    }
    
    CGRect leftFrame = CGRectMake([[self.dic objectForKey:@"leftX"] floatValue],
                                  [[self.dic objectForKey:@"leftY"] floatValue], 84, 86);
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(turnRight)];
                         [self.bug setFrame:leftFrame];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    bugDead = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dicSettings"];
    NSLog(@"dic: %@", self.dic);
    
    bugDead = NO;
    
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
                         NSLog(@"door opened.");
                     }];
    
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self.tissueTop setFrame:topTissueFrame];
                         [self.tissueButtom setFrame:bottomTissueFrame];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"door opened.");
                     }];
    
    [self turnRight];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    [_bug release];
    [_plate release];
    [super dealloc];
}
@end
