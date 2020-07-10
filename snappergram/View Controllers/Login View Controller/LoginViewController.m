//
//  LoginViewController.m
//  snappergram
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "LoginViewController.h"

#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "NavigationManager.h"
#import "ProfileViewController.h"

#pragma mark - Interface

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

#pragma mark - Implementation

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - User actions

- (IBAction)didTapRegister:(id)sender {
    [self registerUser];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

#pragma mark - Authentication

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    
    newUser.username = _usernameField.text;
    newUser.password = _passwordField.text;
    
    if ([_usernameField.text isEqual:@""] || [_passwordField.text isEqual:@""]) {
        [self showAlert:@"Empty fields"
            withMessage:@"Username or password field empty" completion:nil];
    } else {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"User registration failed: %@", error.localizedDescription);
                [self showAlert:@"Error"
                    withMessage:error.localizedDescription completion:nil];
            } else {
                NSLog(@"User registered successfully");
                
                [self transitionToLoggedInScreen];
            }
        }];
    }
}

- (void)loginUser {
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username
                                 password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self showAlert:@"User login failed"
                withMessage:error.localizedDescription completion:nil];
        } else {
            NSLog(@"User logged in successfully");
            
            [self transitionToLoggedInScreen];
        }
    }];
}

#pragma mark - UI Changes

- (void)showAlert:(NSString *)title withMessage:(NSString *)message completion:(void(^)(void))completion{
    UIAlertController *const alert = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *const okAction = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)transitionToLoggedInScreen {
    SceneDelegate *const sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    [NavigationManager presentLoggedInScreenWithSceneDelegate:sceneDelegate];
}

@end
