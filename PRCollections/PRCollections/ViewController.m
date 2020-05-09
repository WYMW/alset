//
//  ViewController.m
//  PRCollections
//
//  Created by YmWw on 2020/5/1.
//  Copyright © 2020 com.caogenleague.monster. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+retry.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(100, 100, 200, 200);
    imageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imageView];
    
}


@end
