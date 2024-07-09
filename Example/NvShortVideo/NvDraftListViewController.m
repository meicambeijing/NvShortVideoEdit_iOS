//
//  NvDraftListViewController.m
//  NvShortVideo
//
//  Created by 美摄 on 2022/2/25.
//

#import "NvDraftListViewController.h"

#if __has_include(<NvShortVideoCore/NvShortVideoCore.h>)
#import <NvShortVideoCore/NvShortVideoCore.h>
#else
#import "NvShortVideoCore.h"
#endif


@interface NvDraftCell : UITableViewCell

@property(nonatomic,strong)UIImageView* coverImageView;
@property(nonatomic,strong)UILabel* infoLabel;

@end

@implementation NvDraftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.coverImageView];
    self.coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
    // 宽度和高度约束
    [NSLayoutConstraint activateConstraints:@[
        [self.coverImageView.widthAnchor constraintEqualToConstant:70],
        [self.coverImageView.heightAnchor constraintEqualToConstant:70],
        
        // 垂直中心约束
        [self.coverImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        // 左边距约束
        [self.coverImageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:20]
    ]];
    self.coverImageView.backgroundColor = [UIColor blackColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, rect.size.width-30, 40)];
    self.infoLabel.textColor = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1.0];
    self.infoLabel.font = [UIFont systemFontOfSize:12];
    self.infoLabel.text = NSLocalizedString(@"add_description", @"请添加描述～");
    [self.contentView addSubview:self.infoLabel];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // 左边距和顶部约束
    [NSLayoutConstraint activateConstraints:@[
        // 左边距约束
        [self.infoLabel.leftAnchor constraintEqualToAnchor:self.coverImageView.rightAnchor constant:15],
        
        // 顶部约束
        [self.infoLabel.topAnchor constraintEqualToAnchor:self.coverImageView.topAnchor]
    ]];
}

-(void)loadDraftModel:(NvEditProjectInfo*)draftModel{
    NSString* imagePath = draftModel.coverImagePath;
    self.coverImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    self.infoLabel.text = (draftModel.projectDescription && draftModel.projectDescription.length>0) ? draftModel.projectDescription : NSLocalizedString(@"add_description", @"请添加描述～");
}

@end

@interface NvDraftListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UILabel* infoLabel;

@property(nonatomic,strong)NSMutableArray<NvEditProjectInfo*> * draftArray;

@property (nonatomic, strong) NvVideoConfig *config;

@end

@implementation NvDraftListViewController

- (instancetype)initWithConfig:(NvVideoConfig *)config {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"DraftList", @"草稿箱");
    
    self.view.backgroundColor = [UIColor colorWithRed:18/255.f green:18/255.f blue:18/255.f alpha:1];
    CGFloat safeAreaTopHeight = [UIApplication sharedApplication].statusBarFrame.size.height+ 44.0;
    CGRect rect = [UIScreen mainScreen].bounds;
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, safeAreaTopHeight+20, rect.size.width-30, 40)];
    self.infoLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    self.infoLabel.font = [UIFont systemFontOfSize:13];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.text = NSLocalizedString(@"DraftListTip", nil);
    [self.view addSubview:self.infoLabel];
    [self.infoLabel sizeToFit];
    self.infoLabel.frame = CGRectMake(self.infoLabel.frame.origin.x, self.infoLabel.frame.origin.y, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height);
    
    CGFloat tableY = self.infoLabel.frame.origin.y+self.infoLabel.frame.size.height;
    CGRect tableRect = CGRectMake(0, tableY, rect.size.width, rect.size.height - tableY);
    self.tableView = [[UITableView alloc] initWithFrame:tableRect style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:NvDraftCell.self forCellReuseIdentifier:@"NvDraftCell"];
    
    self.draftArray = [NvModuleManager projectList].mutableCopy;
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.draftArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NvDraftCell* cell = (NvDraftCell*)[tableView dequeueReusableCellWithIdentifier:@"NvDraftCell" forIndexPath:indexPath];
    NvEditProjectInfo* draftModel = self.draftArray[indexPath.row];
    [cell loadDraftModel:draftModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NvEditProjectInfo* draftModel = self.draftArray[indexPath.row];
    [NvModuleManager.sharedInstance reeditProject:draftModel presentViewController:self config:self.config];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DraftDelete", @"确定删除") message:@"" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DraftConfirm", @"是") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NvEditProjectInfo* draftModel = self.draftArray[indexPath.row];
            if([NvModuleManager deleteDraft:draftModel.projectId]) {
                [self.draftArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                NSLog(@"删除失败");
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DraftCancel", @"否") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
