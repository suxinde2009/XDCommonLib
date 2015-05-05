//
//  ViewController.m
//  XDCommonLib
//
//  Created by su xinde on 15/5/5.
//  Copyright (c) 2015年 su xinde. All rights reserved.
//

#import "ViewController.h"

#import "MulticastDelegateDemoVC.h"

@interface ViewController ()
{
    NSMutableArray *mTestCases;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mTestCases = [@[] mutableCopy];
    [mTestCases addObject:@"多播委托-MulticastDelegateDemoVC"];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mTestCases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text = mTestCases[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger idx = indexPath.row;
    
    switch (idx) {
        case 0:{
            MulticastDelegateDemoVC *controller = [[MulticastDelegateDemoVC alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
        } break;
            
        case 1:{
            
        } break;
            
        case 2:{
            
        } break;
            
        case 3:{
            
        } break;
            
        case 4:{
            
        } break;
            
        case 5:{
            
        } break;
            
        case 6:{
            
        } break;
            
        case 7:{
            
        } break;
            
        default:
            break;
    }
}


#pragma mark - 


@end
