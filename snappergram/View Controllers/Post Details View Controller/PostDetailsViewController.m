//
//  PostDetailsViewController.m
//  snappergram
//
//  Created by meganyu on 7/7/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "PostDetailsViewController.h"

@import Parse;

#pragma mark - Interface

@interface PostDetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

#pragma mark - Implementation

@implementation PostDetailsViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPost];
}

- (void)loadPost {
    self.photoImageView.file = _post.image;
    [self.photoImageView loadInBackground];
    
    [self.captionLabel setText:_post.caption];
    NSLog(@"Time created: %@", [_post getCreatedAtString]);
    [self.timestampLabel setText:[_post getCreatedAtString]];
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
