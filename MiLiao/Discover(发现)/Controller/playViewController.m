//
//  PlayViewController.m
//  MiLiao
//
//  Created by King on 2018/1/12.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "PlayViewController.h"

#import <AliyunVodPlayerSDK/AliyunVodPlayerDefine.h>

/**** View ****/
#import "PlayCollectionViewCell.h"

@interface PlayViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end


static NSString *CellID_PlayCollectionViewCell = @"PlayCollectionViewCell";


@implementation PlayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self config];
    
}
- (IBAction)backButonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)config {
    [self.collectionView registerNib:[UINib nibWithNibName:CellID_PlayCollectionViewCell bundle:nil] forCellWithReuseIdentifier:CellID_PlayCollectionViewCell];
    self.layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID_PlayCollectionViewCell forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayCollectionViewCell *temp =  (PlayCollectionViewCell*)cell;
//    AliyunVodPlayerState playState = [temp playerState];
//
//    if (playState == AliyunVodPlayerStateIdle || playState == AliyunVodPlayerStatePrepared) {
//         [temp prepare];
//    }
//    if (playState == AliyunVodPlayerStatePause) {
//        [temp resumePlay];
//    }
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    PlayCollectionViewCell *temp =  (PlayCollectionViewCell*)cell;
//     AliyunVodPlayerState playState = [temp playerState];
//    if (playState == AliyunVodPlayerStateIdle
//        ||
//        playState == AliyunVodPlayerStatePrepared) {
//        
//    }
//    if (playState == AliyunVodPlayerStatePlay) {
//        [temp pausePlay];
//    }
}






@end
