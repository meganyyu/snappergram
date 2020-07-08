//
//  Post.h
//  snappergram
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

/** Creates a new Post object, initializes its properties, and then saves it to Parse asynchronously. Then carries out specified completion block, reporting whether it was a success or not. */
+ (void) postUserImage: ( UIImage * _Nullable )image
           withCaption: ( NSString * _Nullable )caption
        withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (NSString *)getCreatedAtString;

@end

NS_ASSUME_NONNULL_END
