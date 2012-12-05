//
//  Bug.m
//  FunBug
//
//  Created by liuwei on 12-12-5.
//  Copyright (c) 2012年 liuwei. All rights reserved.
//

#import "Bug.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

@implementation Bug

- (id)initWithSuperView:(ViewController *)superView
{
    UIImage *bugImage = [UIImage imageNamed:@"bug.png"]; //000
    
    self = [super initWithImage:bugImage];
    if (self) {
        // Initialization code
        [self setStartPoint:CGPointMake(arc4random()%111, 111 + arc4random()%111)];
        [self setEndPoint:CGPointMake(arc4random()%111, 111 + arc4random()%111)];
        
        CGRect frame = CGRectMake(self.startPoint.x, self.startPoint.y, 84, 86);
        [self setUserInteractionEnabled:YES];
        [self setFrame:frame];
        [self turnTo];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"bug touchesBegan.");
    self.dead = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superView];
    CGRect bugFrame = [[[self layer] presentationLayer] frame];
    
    if (CGRectContainsPoint(bugFrame, touchPoint)) {
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
                             [self setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                         }];
        
        [(ViewController*)self.superView bePressed:self];
    } 
}


/*****************当音频播放完毕调用这个函数释放资源，避免内存泄露*******************/
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)turnTo
{
    if (self.dead) {
        return;
    }
    
    float w = self.startPoint.x - self.endPoint.x;
    float h = self.startPoint.y - self.endPoint.y;
    
    if (w < 0)
    {
        w = -w;
    }
    if (h < 0)
    {
        h = -h;
    }
    
    //tan(<#double#>)
    
    [UIView animateWithDuration:0.5
                          delay:1.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveTo)];
                         self.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

- (void)moveTo
{ 
    if (self.dead) {
        return;
    }
    
    
    CGRect toFrame = CGRectMake(self.endPoint.x, self.endPoint.y, 84, 86);
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(turnBack)];
                         [self setFrame:toFrame];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

- (void)turnBack
{
    if (self.dead) {
        return;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(moveBack)];
                         self.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

- (void)moveBack
{
    CGRect leftFrame = CGRectMake(self.startPoint.x, self.startPoint.y, 84, 86);
    
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:(UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [UIView setAnimationDelegate:self];
                         [UIView setAnimationDidStopSelector:@selector(turnTo)];
                         [self setFrame:leftFrame];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finished turn right");
                     }];
}

@end
