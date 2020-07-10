//
//  InfiniteScrollActivityView.h
//  snappergram
//
//  Created by meganyu on 7/8/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfiniteScrollActivityView : UIView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
