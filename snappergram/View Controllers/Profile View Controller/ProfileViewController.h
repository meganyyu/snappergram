//
//  ProfileViewController.h
//  snappergram
//
//  Created by meganyu on 7/8/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
