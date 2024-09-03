//
//  NvPublicViewController.m
//  NvShortVideo
//
//  Created by 美摄 on 2022/2/22.
//

#import "NvPublicViewController.h"
#if __has_include(<NvShortVideoCore/NvShortVideoCore.h>)
#import <NvShortVideoCore/NvShortVideoCore.h>
#else
#import "NvShortVideoCore.h"
#endif

@interface NvPublicViewController ()<NvModuleManagerCompileStateDelegate>
{
    NvModuleManager* _moduleManager;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveBt;
@property (weak, nonatomic) IBOutlet UIButton *compileBt;
@property (weak, nonatomic) IBOutlet UIButton *saveCoverBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveCoverleading;

@end

@implementation NvPublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary*attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    self.navigationController.navigationBar.titleTextAttributes = attributes;

    self.navigationItem.title = NSLocalizedString(@"Publish", @"发布");
    
    UIImage *image = [UIImage imageNamed:@"navigation_whiteback"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBtClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    // Do any additional setup after loading the view.
    _moduleManager = [NvModuleManager sharedInstance];
    _moduleManager.compileDelegate = self;
    self.imageView.image = [UIImage imageWithContentsOfFile:self.imagePath];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 2;
    self.saveBt.clipsToBounds = YES;
    self.saveBt.layer.cornerRadius = 2;
    self.compileBt.clipsToBounds = YES;
    self.compileBt.layer.cornerRadius = 2;
    
    self.saveBt.hidden = !self.hasDraft;
    
    UITapGestureRecognizer* _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:_tap];
    
    // _placeholderLabel
    UILabel* placeHolderLabel = [[UILabel alloc]init];
    placeHolderLabel.text = NSLocalizedString(@"Publish_Info", @"");
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    self.textView.text = self.draftInfo;
    
    [self.compileBt setTitle:NSLocalizedString(@"Save_Video", @"") forState:(UIControlStateNormal)];
    [self.saveBt setTitle:NSLocalizedString(@"Save_Draft", @"") forState:(UIControlStateNormal)];
    [self.saveCoverBt setTitle:NSLocalizedString(@"Save_Cover", @"") forState:(UIControlStateNormal)];
    
    self.compileBt.layer.cornerRadius = 10;
    self.saveBt.layer.cornerRadius = 10;
    self.saveCoverBt.layer.cornerRadius = 10;
    
    self.saveBt.backgroundColor = [[UIColor alloc]initWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:1];
    self.compileBt.backgroundColor = [[UIColor alloc]initWithRed:252/255.0 green:62/255.0 blue:90/255.0 alpha:1];
    self.saveCoverBt.backgroundColor = [[UIColor alloc]initWithRed:252/255.0 green:62/255.0 blue:90/255.0 alpha:1];
    
    self.imageView.layer.cornerRadius = 8;
    self.imageView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.frame.size.height - 15, self.imageView.frame.size.width, 15)];
    label.text = NSLocalizedString(@"Select_Cover", @"");
    label.font = [UIFont systemFontOfSize:10];
    label.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:label];
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelectCover)]];
    if (!self.hasDraft){
        self.saveCoverleading.constant = -(2*self.saveCoverleading.constant + self.saveBt.frame.size.width);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)leftBtClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapSelectCover{
    [_moduleManager selectCoverWithNavigationController:self.navigationController
                                      completionHandler:^(NSString * _Nonnull path) {
        self.imagePath = path;
        self.imageView.image = [UIImage imageWithContentsOfFile:self.imagePath];
    }];
}

- (IBAction)saveBtClicked:(UIButton *)sender {
    if([_moduleManager saveCurrentDraftWithDraftInfo:self.textView.text]){
        [self finish:nil];
    }else{
        [NvTipToast showInfoWithMessage:NSLocalizedString(@"Save_Failed", @"")];
    }
}

- (IBAction)compileBtClicked:(UIButton *)sender {
    [NvTipToast showLoading];
    if([_moduleManager compileCurrentTimeline:nil]){
        
    }else{
        [NvTipToast dismiss];
        [NvTipToast showInfoWithMessage:NSLocalizedString(@"Save_Failed", @"")];
    }
}

- (IBAction)saveCoverClicked:(UIButton *)sender {
    [_moduleManager saveCover:self.imagePath with:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success){
                [NvTipToast showInfoWithMessage:NSLocalizedString(@"Save_Successful", @"")];
            }else{
                [NvTipToast showInfoWithMessage:NSLocalizedString(@"Save_Failed", @"")];
            }
        });
    }];
}

-(void)viewTap:(UITapGestureRecognizer*)tap{
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
}

- (void)finish:(NSString *)outputPath{
    [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    if (self.presentingViewController.presentingViewController){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self->_moduleManager exitVideoEdit:self.projectId];
        }];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self->_moduleManager exitVideoEdit:self.projectId];
        }];
    }
}

#pragma mark - NvModuleManagerCompileStateDelegate
- (void)didCompileCompleted:(NSString*)outputPath error:(NSError*)error{
//    WeakObjc(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [NvTipToast dismiss];
        if (error){
            [NvTipToast showInfoWithMessage:NSLocalizedString(@"Save_Failed", @"")];
        }else{
            [NvTipToast showInfoWithMessage:NSLocalizedString(@"Save_Successful", @"")];
        }
    });
}

- (void)didCompileFloatProgress:(float)progress{
    NSLog(@"didCompileFloatProgress:%f",progress);
}

@end

