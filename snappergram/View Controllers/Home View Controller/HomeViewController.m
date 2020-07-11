//
//  HomeViewController.m
//  snappergram
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "HomeViewController.h"

#import "InfiniteScrollActivityView.h"
#import "LoginViewController.h"
#import "NavigationManager.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "PostCollectionCell.h"
#import "PostDetailsViewController.h"
#import "SceneDelegate.h"

#pragma mark - Constants

static NSString *const kAuthorKey = @"author";
static NSString *const kCreatedAtKey = @"createdAt";
static NSString *const kPostCollectionCellID = @"PostCollectionCell";
static NSString *const kPostDetailsSegueID = @"postDetailsSegue";

#pragma mark - Interface

@interface HomeViewController () <PostCollectionCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSArray *postArray;
@property int postQueryLimit;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property bool isMoreDataLoading;
@property (nonatomic, strong) InfiniteScrollActivityView *loadingMoreView;

@end

#pragma mark - Implementation

@implementation HomeViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _flowLayout = (UICollectionViewFlowLayout *) _collectionView.collectionViewLayout;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    
    _postQueryLimit = 10;
    _isMoreDataLoading = false;
    [self loadPosts];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadPosts)
              forControlEvents:UIControlEventValueChanged];
    [_collectionView insertSubview:_refreshControl
                           atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, _collectionView.contentSize.height, _collectionView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreView.hidden = true;
    [_collectionView addSubview:_loadingMoreView];
    
    UIEdgeInsets insets = _collectionView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    _collectionView.contentInset = insets;
}

- (void)loadPosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:kCreatedAtKey];
    [postQuery includeKey:kAuthorKey];
    postQuery.limit = _postQueryLimit;
    postQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.isMoreDataLoading = false;
            [self.loadingMoreView stopAnimating];
            self.postQueryLimit = (int) posts.count + 5;
            
            self.postArray = posts;
            
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"ERROR FETCHING POSTS: %@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - User Interaction

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    [NavigationManager presentLoggedOutScreenWithSceneDelegate:sceneDelegate];
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        NSLog(@"User logged out successfully");
    }];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _postArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPostCollectionCellID forIndexPath:indexPath];
    cell.post = _postArray[indexPath.item];
    [cell refreshPost];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = _collectionView.frame.size.width;
    CGFloat itemHeight = itemWidth * 1.25;
    return CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - PostCollectionCellDelegate methods

- (void)postCollectionCell:(PostCollectionCell *)postCollectionCell
                    didTap:(Post *)post {
    NSLog(@"Reached postCollectionCell:didTap: method");
    [self performSegueWithIdentifier:kPostDetailsSegueID
                              sender:post];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = _collectionView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - _collectionView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && _collectionView.isDragging) {
            _isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, _collectionView.contentSize.height, _collectionView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreView.frame = frame;
            [_loadingMoreView startAnimating];
            
            // ... Code to load more results ...
            NSLog(@"Letting you know that we're pulling up more data! Post query limit: %d", _postQueryLimit);
            [self loadPosts];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([[segue identifier] isEqualToString:kPostDetailsSegueID]) {
        Post *tappedPost = sender;
        
        UINavigationController *navigationController = [segue destinationViewController];
        PostDetailsViewController *postDetailsViewController = (PostDetailsViewController *)navigationController.topViewController;
        postDetailsViewController.post = tappedPost;
        
        NSLog(@"HomeViewController preparing for segue!");
    }
}

@end
