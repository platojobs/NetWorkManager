//
//  DavRusultVC.m
//  PayMent_IOS
//
//  Created by 崔曦 on 2018/11/30.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import "DavRusultVC.h"

@interface DavRusultVC ()
@property (weak, nonatomic) IBOutlet UITextView *dav_textView;

@end

@implementation DavRusultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableString * str3 = [[NSMutableString alloc]initWithString:self.result];
    
    [str3 replaceOccurrencesOfString:@"\\" withString:@"" options:1 range:NSMakeRange(0, str3.length)];
    [str3 replaceOccurrencesOfString:@"," withString:@"\n" options:1 range:NSMakeRange(0, str3.length)];
    NSLog(@"----%@",str3);
    self.dav_textView.text=str3;
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
