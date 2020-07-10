//
//  NavigationManager.m
//  snappergram
//
//  Created by meganyu on 7/10/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "NavigationManager.h"

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "ProfileViewController.h"

#pragma mark - Constants

static NSString *const kMainStoryboardID = @"Main";
static NSString *const kHomeNavigationControllerID = @"HomeNavigationController";
static NSString *const kHomeViewControllerID = @"HomeViewController";
static NSString *const kLoginViewControllerID = @"LoginViewController";
static NSString *const kProfileNavigationControllerID = @"ProfileNavigationController";
static NSString *const kProfileViewControllerID = @"ProfileViewController";

@implementation NavigationManager

+ (void)presentLoggedOutScreenWithSceneDelegate:(SceneDelegate *)sceneDelegate {
    UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:kMainStoryboardID
                                                               bundle:nil];
    
    LoginViewController *const loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginViewControllerID];
    sceneDelegate.window.rootViewController = loginViewController;
    [sceneDelegate.window makeKeyAndVisible];
}

+ (void)presentLoggedInScreenWithSceneDelegate:(SceneDelegate *)sceneDelegate {
    MainTabBarController *const tabBarController = [[MainTabBarController alloc] init];
    
    sceneDelegate.window.rootViewController = tabBarController;
    [sceneDelegate.window makeKeyAndVisible];
}

@end
