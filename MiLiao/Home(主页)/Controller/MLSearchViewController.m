//
//  MLSearchViewController.m
//  MiLiao
//
//  Created by Jarvan-zhang on 2018/1/3.
//  Copyright © 2018年 Jarvan-zhang. All rights reserved.
//

#import "MLSearchViewController.h"
#import "HLSearchTableViewCell.h"
#import "MainMananger.h"
#import "FSBaseViewController.h"

#define searchTabTag        101
#define likeTabTag          102
#define itemButtonTag       1000

@interface MLSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate> {
    UISearchBar     *_searchBar;
    UITableView     *_searchTableView;
    UITableView    *_likeTableView;
    NSUserDefaults  *_userDefaults;
    NSMutableArray  *_likeMuArr;
    UIView          *_hisView;
    NSMutableArray  *_hisMuArr;
    NSMutableArray  *_searchArr;
    
    float       itemHeight;
    WomanModel  *_womanModel;
}

@end

@implementation MLSearchViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIColor *color = [UIColor clearColor];
    [self setStatusBarBackgroundColor:color];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStatusBarBackgroundColor:ML_Color(242, 242, 242, 1)];
    self.view.backgroundColor = ML_Color(242, 242, 242, 1);
    
    _searchArr = [NSMutableArray array];
    _likeMuArr = [NSMutableArray array];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _hisMuArr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:@"historyArr"]];
    
    [self searchBar];
//    _searchBar = [[UISearchBar alloc] init];
//    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    _searchBar.delegate = self;
//    _searchBar.placeholder = @"请输入";
//    _searchBar.frame = CGRectMake(10, ML_StatusBarHeight+8, WIDTH-94, 35);
//    _searchBar.layer.cornerRadius = 14.0;
//    _searchBar.layer.masksToBounds = YES;
//    _searchBar.tintColor = [UIColor blackColor];
//    _searchBar.barTintColor = [UIColor whiteColor];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(WIDTH-72, ML_StatusBarHeight+8, 60, 35);
    [cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancleButton.layer.cornerRadius = 6.0;
    cancleButton.backgroundColor = NavColor;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchBar];
    [self.view addSubview:cancleButton];
    
    _likeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ML_StatusBarHeight+60, WIDTH  , HEIGHT-ML_StatusBarHeight-60) style:UITableViewStylePlain];
    _likeTableView.tag = likeTabTag;
    _likeTableView.delegate = self;
    _likeTableView.dataSource = self;
    _likeTableView.scrollEnabled = NO;
    _likeTableView.backgroundColor = Color242;
    _likeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_likeTableView];
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ML_StatusBarHeight+60, WIDTH , HEIGHT-ML_StatusBarHeight-60) style:UITableViewStylePlain];
    _searchTableView.tag = searchTabTag;
    _searchTableView.delegate = self;
    _searchTableView.hidden = YES;
    _searchTableView.dataSource = self;
    _searchTableView.backgroundColor = Color242;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore:)];
//    _searchTableView.mj_footer = footer;
    
    [self.view addSubview:_searchTableView];
    
}
//搜索框
- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, ML_StatusBarHeight+8, WIDTH-94, 35)];
        _searchBar.placeholder = @"请输入";
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.delegate = self;
        _searchBar.tintColor =  Color75;
        //取出textfield
        
        UITextField *searchField=[_searchBar valueForKey:@"_searchField"];
        
        //        searchField.backgroundColor = [UIColor grayColor];
        //        searchField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:@"ic_map_topbar_search"]];
        //        searchField.background = [UIImage imageNamed:@"ic_map_topbar_search"];
        //改变searcher的textcolor
        searchField.borderStyle = UITextBorderStyleNone;
        //        searchField.background = [UIImage imageNamed:@"ic_top"];
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.layer.cornerRadius = 14.0;
        searchField.layer.masksToBounds = YES;
//        searchField.placeholder = @"请输入";
        searchField.font = [UIFont systemFontOfSize:14.0];
        searchField.leftViewMode = UITextFieldViewModeAlways;
        UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        view.backgroundColor = [UIColor clearColor];
        searchField.leftView = view;
        searchField.textColor = Color75;
        //改变placeholder的颜色
//
//        [searchField setValue:[UIColor whiteColor]forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}
#pragma mark - 加载更多
- (void)footerLoadMore:(MJRefreshAutoNormalFooter *)footer {
    [footer endRefreshing];
}
//点击清空按钮
- (void)clearButton:(UIButton *)butt {
    [_userDefaults removeObjectForKey:@"historyArr"];
    _hisMuArr = [NSMutableArray array];
    [_likeTableView reloadData];
}
#pragma mark - tableview的组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _likeTableView) {
//        return 2;
        return 1;
    }
    return 1;
}
#pragma mark  tablecell每组个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {
    if (tableView.tag == likeTabTag) {
        if (sectio == 0) {
            return 1;
        }
//        return 5;
    }
    return _searchArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == likeTabTag) {
        if (indexPath.section == 0) {
            if (_hisMuArr.count > 0) {
                CGFloat w = 12;
                CGFloat h = 31;
                
                for (int i = 0; i < _hisMuArr.count; i++) {
                    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.tag = itemButtonTag+i;
                    [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    CGSize buttonSize = [NSStringSize getNSStringHeight:_hisMuArr[i] Font:12.0];
                    itemButton.backgroundColor = ML_Color(229, 229, 229, 1);
                    [itemButton setTitleColor:ML_Color(75, 75, 75, 1) forState:UIControlStateNormal];
                    itemButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
                    [itemButton setTitle:_hisMuArr[i] forState:UIControlStateNormal];
                    itemButton.layer.cornerRadius = 13;
                    
                    itemButton.frame = CGRectMake(w, h, buttonSize.width+18 , 27);
                    if(w + buttonSize.width + 24 > WIDTH){
                        w = 12;
                        h = h + itemButton.frame.size.height + 12;
                        itemButton.frame = CGRectMake(w, h, buttonSize.width+18, 27);
                    }
                    
                    w = itemButton.frame.size.width + itemButton.frame.origin.x+18;
                    
                    if (i == _hisMuArr.count-1) {
                        itemHeight = itemButton.frame.origin.y+27;
                    }
                    
                }
                return itemHeight+35;
            } else {
                return 19;
            }
        }
        return 74;
    }
    return 74;
}

#pragma mark 添加tabelcell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _likeTableView) {
        if (indexPath.section == 0) {
            static NSString *identifier = @"headCell";
            UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            for(id subView in cell.contentView.subviews){
                if(subView){
                    [subView removeFromSuperview];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = Color242;
            if (_hisMuArr.count > 0) {
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 15)];
                titleLabel.text = @"历史记录";
                titleLabel.textColor = Color75;
                titleLabel.font = [UIFont systemFontOfSize:15.0];
                
                UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
                clearButton.frame = CGRectMake(WIDTH-72, 0, 60, 30);
                clearButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
               
                [clearButton addTarget:self action:@selector(clearButton:) forControlEvents:UIControlEventTouchUpInside];
                [clearButton setTitleColor:ML_Color(153, 153, 153, 1) forState:UIControlStateNormal];
                [clearButton setTitle:@"清空" forState:UIControlStateNormal];
                
                CGFloat w = 12;
                CGFloat h = 31;
                
                for (int i = 0; i < _hisMuArr.count; i++) {
                    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    itemButton.tag = itemButtonTag+i;
                    [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    CGSize buttonSize = [NSStringSize getNSStringHeight:_hisMuArr[i] Font:12.0 maxSize:CGSizeMake(WIDTH-48, 13)];
//                    CGSize buttonSize = [NSStringSize getNSStringHeight:_hisMuArr[i] Font:12.0];
                    itemButton.backgroundColor = ML_Color(229, 229, 229, 1);
                    [itemButton setTitleColor:ML_Color(75, 75, 75, 1) forState:UIControlStateNormal];
                    itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
                    itemButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
                    [itemButton setTitle:_hisMuArr[i] forState:UIControlStateNormal];
                    itemButton.layer.cornerRadius = 13;
                    
                    itemButton.frame = CGRectMake(w, h, buttonSize.width+18 , 27);
                    if(w + buttonSize.width + 24 > WIDTH){
                        w = 12;
                        h = h + itemButton.frame.size.height + 12;
                        itemButton.frame = CGRectMake(w, h, buttonSize.width+18, 27);
                    }
                    
                    w = itemButton.frame.size.width + itemButton.frame.origin.x+18;
                    
                    if (i == _hisMuArr.count-1) {
                        itemHeight = itemButton.frame.origin.y+27;
                    }
                    [cell.contentView addSubview:itemButton];
                }
                UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(12, itemHeight+16, 100, 15)];
                titleLabel1.text = @"猜你喜欢";
                titleLabel1.font = [UIFont systemFontOfSize:15.0 weight:0.6];
                
                [cell.contentView addSubview:titleLabel];
                [cell.contentView addSubview:clearButton];
//                [cell.contentView addSubview:titleLabel1];
            } else {
                UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 15)];
                titleLabel1.text = @"猜你喜欢";
                titleLabel1.font = [UIFont systemFontOfSize:15.0 weight:0.6];
                
//                [cell.contentView addSubview:titleLabel1];
            }
            
            return cell;
        } else {
            static NSString *identifier = @"likecell";
            HLSearchTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[HLSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.headImageView.image = [UIImage imageNamed:@"aaa"];
            cell.nameLabel.text = @"大范围";
            cell.messageLabel.text = @"拉单是拉萨快递发";
            cell.seeLabel.text = @"123.3万";
            
            return cell;
        }
        
    } else {
        static NSString *identifier = @"cell";
        HLSearchTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[HLSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        _womanModel = [[WomanModel alloc]initWithDictionary:_searchArr[indexPath.row]];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:_womanModel.headUrl] placeholderImage:nil];
        cell.nameLabel.text = _womanModel.nickname;
        cell.messageLabel.text = _womanModel.descriptionStr;
        cell.seeLabel.text = [NSString stringWithFormat:@"%@关注",_womanModel.fansNum];
        
        return cell;
    }
    
}
#pragma mark 点击tablecell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    if (tableView.tag == likeTabTag) {
        
    } else {
        _womanModel = [[WomanModel alloc]initWithDictionary:_searchArr[indexPath.row]];
        VideoUserModel *videoUserModel = [_searchArr objectAtIndex:indexPath.row];
        FSBaseViewController *baseVC = [[FSBaseViewController alloc]init];
        baseVC.videoUserModel = videoUserModel;
        baseVC.user_id = _womanModel.user_id;
        
        [self.navigationController pushViewController:baseVC animated:YES];
        
    }
    
}
// 搜索接口
- (void)searchNickName:(NSString *)str {
    _searchTableView.hidden = NO;
    [MainMananger NetGetgetAnchorInfoNickName:str token:[_userDefaults objectForKey:@"token"] userid:@"" success:^(NSDictionary *info) {
        NSLog(@"----%@",info);
        NSInteger resultCode = [info[@"resultCode"] integerValue];
        _searchArr = [NSMutableArray array];
        if (resultCode == SUCCESS) {
            _searchArr = [info objectForKey:@"data"];
        }
         [_searchTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        _searchTableView.hidden = NO;
        _likeTableView.hidden = YES;
    } else {
        _searchTableView.hidden = YES;
        _likeTableView.hidden = NO;
    }
}
//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    if (searchBar.text.length > 0) {
        if (_hisMuArr.count < 10) {
            [_hisMuArr insertObject:searchBar.text atIndex:0];
        } else {
            [_hisMuArr removeObjectAtIndex:_hisMuArr.count-1];
            [_hisMuArr insertObject:searchBar.text atIndex:0];
        }
        [_userDefaults removeObjectForKey:@"historyArr"];
        [_userDefaults setObject:_hisMuArr forKey:@"historyArr"];
       
    }
    _likeTableView.hidden = YES;
    [_likeTableView reloadData];
    
    [self searchNickName:searchBar.text];
    
}
//点击历史记录
- (void)itemButtonClick:(UIButton *)butt {
    [_searchBar resignFirstResponder];
    _likeTableView.hidden = YES;
    [_likeTableView reloadData];
    _searchTableView.hidden = NO;
    NSString *searchStr = _hisMuArr[butt.tag-itemButtonTag];
    [self searchNickName:searchStr];
}
- (void)cancleClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
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

@end
