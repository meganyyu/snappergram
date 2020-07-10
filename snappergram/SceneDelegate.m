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
#import "NavigationManager.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

#pragma mark - Interface

@interface SceneDelegate ()

@end

#pragma mark - Implementation

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    PFUser *user = [PFUser currentUser];

    if (user != nil) {
        NSLog(@"Welcome back %@ 😀", user.username);
        [NavigationManager presentLoggedInScreenWithSceneDelegate:self];
    } else {
        [NavigationManager presentLoggedOutScreenWithSceneDelegate:self];
    }
}

@end
