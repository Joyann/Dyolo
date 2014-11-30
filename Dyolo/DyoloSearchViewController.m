//
//  DyoloSearchViewController.m
//  Dyolo
//
//  Created by joyann on 14/11/30.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import "DyoloSearchViewController.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

static NSString *const DouBanSearchURLString = @"https://api.douban.com/v2/movie/search?";

@interface DyoloSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation DyoloSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // Add tap gesture to hide keyboard.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
}

#pragma mark - HideKeyboard

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        [self performSearch];
    }
}

#pragma mark - PerformSearch

- (void)performSearch
{
    [self.searchBar resignFirstResponder];
    
    [self.operationQueue cancelAllOperations];

    NSURL *url = [self URLFromSearchText];
    
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:URLRequest];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [self.operationQueue addOperation:operation];
}

#pragma mark - GetURLFromSearchText

- (NSURL *)URLFromSearchText
{
    NSString *text = [self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@tag=%@", DouBanSearchURLString, text]];
    return url;
}

@end

































