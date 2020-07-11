//
//  CreatePostViewController.m
//  snappergram
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "CreatePostViewController.h"
#import <UIKit/UIKit.h>
#import "Post.h"

#pragma mark - Interface

@interface CreatePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

#pragma mark - Implementation

@implementation CreatePostViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePickerVC = [UIImagePickerController new];
    _imagePickerVC.delegate = self;
    _imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        _imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self registerForKeyboardNotifications];
}

#pragma mark - User actions

- (IBAction)onImageTap:(UITapGestureRecognizer *)sender {
    NSLog(@"Requested to pick image!");
    [self presentViewController:_imagePickerVC
                       animated:YES
                     completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    UIImage *resizedImage = [self resizeImage:_photoImageView.image
                                     withSize:CGSizeMake(250, 250)];
    
    [Post postUserImage:resizedImage
            withCaption:_captionTextView.text
         withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully created post!");
            [self dismissViewControllerAnimated:true
                                     completion:nil];
        } else {
            NSLog(@"Post creation failed with error %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Image Controls

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    [_photoImageView setImage:editedImage];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image
                withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Acommodate keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(keyboardWasShown:)
            name:UIKeyboardDidShowNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
             selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *const userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;

    CGRect frame = self.view.frame;
    frame.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(frame, _captionTextView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _captionTextView.frame.origin.y-keyboardSize.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
