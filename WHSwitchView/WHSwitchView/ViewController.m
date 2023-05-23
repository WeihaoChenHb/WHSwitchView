//
//  ViewController.m
//  WHSwitchView
//
//  Created by CWH on 2023/5/23.
//

#import "ViewController.h"
#import "WHSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    WHSwitch *switchView = [[WHSwitch alloc] initWithFrame:CGRectMake(100, 100, 50, 30)];
    switchView.onTintColor = UIColor.orangeColor;
    switchView.offTintColor = UIColor.darkGrayColor;
    switchView.thumbTintColor = UIColor.greenColor;
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:switchView];
}

- (void)switchAction:(WHSwitch *)switchView {
    NSLog(@"%d",switchView.isOn);
}


@end
