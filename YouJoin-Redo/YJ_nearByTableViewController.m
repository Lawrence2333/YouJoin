//
//  YJ_nearByTableViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/10.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_nearByTableViewController.h"
#import "YJ_networkTool.h"
#import "YJ_userInfo.h"
#import "NSString+Password.h"
#import "YJ_friendListCell.h"
#import "YJ_friendList.h"
#import "UIImageView+WebCache.h"
#import "NSString+CutLastChar.h"
#import "UIImage+SmallImage.h"
#import "UIImage+Circle.h"


#import <CoreLocation/CoreLocation.h>

@interface YJ_nearByTableViewController ()

@property (nonatomic,strong) YJ_friendList *friends ;

@end

@implementation YJ_nearByTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNearByList];
    
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    self.tableView.tableHeaderView = headerImage;
    
}

-(void)setupNearByList{
    
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D locat = locationManager.location.coordinate;
    [locationManager stopUpdatingLocation];
    
    NSMutableArray *locationArray = [NSMutableArray array];
    
    NSString *location0 = [[NSString stringWithFormat:@"%.3f%.3f",locat.longitude-0.001,locat.latitude]MD5];
    NSString *location1 = [[NSString stringWithFormat:@"%.3f%.3f",locat.longitude,locat.latitude-0.001]MD5];
    NSString *location2 = [[NSString stringWithFormat:@"%.3f%.3f",locat.longitude+0.001,locat.latitude-0.001]MD5];
    NSString *location3 = [[NSString stringWithFormat:@"%.3f%.3f",locat.longitude,locat.latitude+0.001]MD5];
    
    [locationArray addObject:location0];
    [locationArray addObject:location1];
    [locationArray addObject:location2];
    [locationArray addObject:location3];
    
    //获取旧位置
    NSString *locationOld = [NSString stringWithFormat:@""];
    locationOld = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@&location_old",[[YJ_userInfo sharedInstance]userID]]];
    
    NSString *locationNow = [NSString stringWithFormat:@"%.3f%.3f",locat.longitude,locat.latitude];
    
    //判断是否改变位置
    YJ_LocationChange locationChange = LocationChangeYes;
    
    if ([locationNow isEqualToString:locationOld]) {
        locationChange = LocationChangeNo;
    }
    
    //保存位置
    [[NSUserDefaults standardUserDefaults]setObject:locationNow forKey:[NSString stringWithFormat:@"%@&location_old",[[YJ_userInfo sharedInstance]userID]]];
    
    [YJ_networkTool getNearByPeopleListWithUserID:[[YJ_userInfo sharedInstance]userID] isLocationChange:locationChange locationArray:locationArray completion:^(NSString *resultStr, NSArray *receicedFriendListDictArray) {
        
        self.friends = [[YJ_friendList alloc]init];
        self.friends.friendList = receicedFriendListDictArray;
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.friendList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_friendListCell *cell = [YJ_friendListCell cellWithTableView:tableView];
    
    cell.friendInfo = self.friends.friendList[indexPath.row];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString fixStringByCutLastChar: cell.friendInfo.friendIconUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.iconView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(40, 40)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
    }];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
