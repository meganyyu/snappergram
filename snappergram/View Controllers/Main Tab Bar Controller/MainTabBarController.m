//
//  MainTabBarController.m
//  snappergram
//
//  Created by meganyu on 7/10/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "MainTabBarController.h"

#import "HomeViewController.h"
#import "ProfileViewController.h"

#pragma mark - Constants

static NSString *const kHomeNavigationControllerID = @"HomeNavigationController";
static NSString *const kHomeViewControllerID = @"HomeViewController";
static NSString *const kMainStoryboardID = @"Main";
static NSString *const kProfileNavigationControllerID = @"ProfileNavigationController";
static NSString *const kProfileViewControllerID = @"ProfileViewController";

static NSString *const kProfileTabIcon = @"profile_tab";
static NSString *const kFeedTabIcon = @"feed_tab";

#pragma mark - Interface

@interface MainTabBarController ()

@end

#pragma mark - Implementation

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:kMainStoryboardID bundle:nil];
    UIViewController *const homeNavigationController = [storyboard instantiateViewControllerWithIdentifier:kHomeNavigationControllerID];
    UIViewController *const profileNavigationController = [storyboard instantiateViewControllerWithIdentifier:kProfileNavigationControllerID];
    
    self.viewControllers = @[homeNavigationController, profileNavigationController];
    
    UIImage *feedTabIcon = [UIImage imageNamed:kFeedTabIcon];
    UIImage *profileTabIcon = [UIImage imageNamed:kProfileTabIcon];
    
    UITabBar *tabBar = (UITabBar *)self.tabBar;
    
    UITabBarItem *feedTabItem = [tabBar.items objectAtIndex:0];
    [feedTabItem setImage:feedTabIcon];
    feedTabItem.title = @"Home";
    
    UITabBarItem *profileTabItem = [tabBar.items objectAtIndex:1];
    [profileTabItem setImage:profileTabIcon];
    profileTabItem.title = @"Profile";
    
    NSLog(@"Reached end of MainTabBarController viewDidLoad");
}

@end
