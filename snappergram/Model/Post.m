//
//  Post.m
//  snappergram
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize postID;
@synthesize userID;
@synthesize author;
@synthesize caption;
@synthesize image;
@synthesize likeCount;
@synthesize commentCount;

// implementing as part of PFSubclassing protocol
+ (NSString *)parseClassName {
    return @"Post";
}

+ (void)postUserImage:(UIImage * _Nullable)image
          withCaption:(NSString *_Nullable)caption
       withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}

/** Gets a UIImage and returns it as a PFFile if possible. */
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (NSString *)getCreatedAtString {
    NSDate *date = self.createdAt;
    
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d HH:mm:ss y";
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;

    return [formatter stringFromDate:date];
}

@end
