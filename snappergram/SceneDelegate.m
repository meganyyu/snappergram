//
//  SceneDelegate.m
//  snappergram
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "SceneDelegate.h"

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

static NSString *const kMainStoryboardID = @"Main";
static NSString *const kHomeNavigationControllerID = @"HomeNavigationController";
static NSString *const kHomeViewControllerID = @"HomeViewController";
static NSString *const kLoginViewControllerID = @"LoginViewController";
static NSString *const kProfileNavigationControllerID = @"ProfileNavigationController";
static NSString *const kProfileViewControllerID = @"ProfileViewController";

static NSString *const kProfileTabIcon = @"profile_tab";
static NSString *const kFeedTabIcon = @"feed_tab";

#pragma mark - Interface

@interface SceneDelegate ()

@end

#pragma mark - Implementation

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    PFUser *user = [PFUser currentUser];

    if (user != nil) {
        NSLog(@"Welcome back %@ 😀", user.username);
        [self presentLoggedInScreen];
    } else {
        [self presentLoggedOutScreen];
    }
}

- (void)presentLoggedInScreen {
    UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:kMainStoryboardID
                                                               bundle:nil];
    
    UITabBarController *const tabBarController = [[UITabBarController alloc] init];
    
    UIViewController *const homeNavigationController = [storyboard instantiateViewControllerWithIdentifier:kHomeNavigationControllerID];
    UIViewController *const profileNavigationController = [storyboard instantiateViewControllerWithIdentifier:kProfileNavigationControllerID];
    tabBarController.viewControllers = @[homeNavigationController, profileNavigationController];
    
    UIImage *feedTabIcon = [UIImage imageNamed:kFeedTabIcon];
    UIImage *profileTabIcon = [UIImage imageNamed:kProfileTabIcon];
    
    UITabBar *tabBar = (UITabBar *)tabBarController.tabBar;
    UITabBarItem *feedTabItem = [tabBar.items objectAtIndex:0];
    [feedTabItem setImage:feedTabIcon];
    UITabBarItem *profileTabItem = [tabBar.items objectAtIndex:1];
    [profileTabItem setImage:profileTabIcon];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)presentLoggedOutScreen {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainStoryboardID
                                                         bundle:nil];

    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginViewControllerID];
    self.window.rootViewController = loginViewController;
    [self.window makeKeyAndVisible];
}

@end
