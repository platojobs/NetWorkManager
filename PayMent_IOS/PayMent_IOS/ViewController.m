//
//  ViewController.m
//  PayMent_IOS
//
//  Created by 崔曦 on 2018/11/30.
//  Copyright © 2018 崔曦. All rights reserved.
//

#import "ViewController.h"
#import "YTKNetwork.h"
#import "DavRequest.h"
#import "DavRusultVC.h"
#define NavFrame  self.navigationController.navigationBar.frame
#define NavHeight NavFrame.size.height

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*davTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.davTable];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"XXXX"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XXXX"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=[NSString stringWithFormat:@"API%ld",indexPath.row];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"序号：%ld",indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        [self requestTestAPI];
    }
    
}

#pragma mark==setter

-(UITableView*)davTable{
    if (!_davTable) {
        _davTable=[[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-NavHeight) style:UITableViewStylePlain];
        NSLog(@"1990%@",NSStringFromCGRect(_davTable.frame));
        _davTable.delegate = self;
        _davTable.dataSource=self;
        _davTable.rowHeight=40;
    }
    return _davTable;
}

-(void)requestTestAPI{
    
    DavRequest *test = [[DavRequest alloc] init];
    [test startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@" responseJSONObject ==  \n %@",request.responseString);
        
        NSString*str=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        [self pushResult:str];
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"requestOperationError == %@",request.error);
    }];
}

-(void)pushResult:(NSString*)result{
    
    DavRusultVC*vc=[DavRusultVC new];
    vc.result=result;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
