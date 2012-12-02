//
//  SettingViewViewController.m
//  FunBug
//
//  Created by liuwei on 12-12-2.
//  Copyright (c) 2012年 liuwei. All rights reserved.
//

#import "SettingViewViewController.h"

@interface SettingViewViewController ()
@property (retain, nonatomic) IBOutlet UITextField *TextLeftX;
@property (retain, nonatomic) IBOutlet UITextField *TextLeftY;
@property (retain, nonatomic) IBOutlet UITextField *TextRightX;
@property (retain, nonatomic) IBOutlet UITextField *TextRightY;

@property (copy, nonatomic) NSString * leftX;
@property (copy, nonatomic) NSString * leftY;
@property (copy, nonatomic) NSString * RightX;
@property (copy, nonatomic) NSString * RightY;

@end

@implementation SettingViewViewController

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //do nothing
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.TextLeftX.text && [self.TextLeftX.text floatValue] != 0)
    {
        self.leftX = self.TextLeftX.text;
    }
    
    if (self.TextLeftY.text && [self.TextLeftY.text floatValue] != 0)
    {
        self.leftY = self.TextLeftY.text;
    }
    
    if (self.TextRightX.text && [self.TextRightX.text floatValue] != 0)
    {
        self.RightX = self.TextRightX.text;
    }
    
    if (self.TextRightY.text && [self.TextRightY.text floatValue] != 0)
    {
        self.RightY = self.TextRightY.text;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.leftX, @"leftX", self.leftY, @"leftY", self.RightX, @"rightX", self.RightY, @"rightY", nil];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"dicSettings"];
    
    if ([textField isEqual:self.TextRightY] ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.TextLeftX becomeFirstResponder];
}

- (void)viewDidLoad  //只加载一次
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.TextLeftX.delegate = self;
    self.TextLeftY.delegate = self;
    self.TextRightX.delegate = self;
    self.TextRightY.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_TextLeftX release];
    [_TextLeftY release];
    [_TextRightX release];
    [_TextRightY release];
    [super dealloc];
}
@end
