//
//  ViewController.m
//  RichTextDemo
//
//  Created by 杨春至 on 2017/6/27.
//  Copyright © 2017年 com.hofon.www. All rights reserved.
//

#import "ViewController.h"
#import "RichTextView.h"
#import "UIButton+Block.h"
#import "UIView+Bound.h"

#ifndef KHeight
#define KHeight [UIScreen mainScreen].bounds.size.height
#endif 
#ifndef KWidth
#define KWidth  [UIScreen mainScreen].bounds.size.width
#endif

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) RichTextView *rTextView;
@property (nonatomic,strong) UIView *bottomTool;
@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,assign) BOOL isEditing;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.rTextView = [[RichTextView alloc]initWithFrame:self.view.bounds];
    self.rTextView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.rTextView];
    [self.view addSubview:self.bottomTool];
    [self configNavi];
}
- (void)configNavi{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"dataSource" style:UIBarButtonItemStyleDone target:self action:@selector(showData)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)showData{
    [self.rTextView setDataSourceFromMainTextAttributeStr];
}
- (void)gotoCamera{
    self.picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
    
}
- (void)gotoAlbumStepbefore{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self gotoAlbum];
    }else{
    }
}

- (void)gotoAlbum{
    self.picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

- (void)endEditingTextView:(UIButton *)btn{
    if (_isEditing) {
        [self.rTextView becomeFirstResponder];
        _isEditing = NO;
        [btn setImage:[UIImage imageNamed:@"编辑状态"] forState:UIControlStateNormal];
    }else{
        _isEditing = YES;
        [btn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter]postNotificationName:UIKeyboardDidHideNotification object:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegaet
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    UIImage *image = [[UIImage alloc]init];
    
    NSString *photoNameStr  = @"";
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    photoNameStr = @"article.png";
    
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImageJPEGRepresentation(image, 0.001);
    }
    {
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        NSString *pngName = [self getLinkStringWithPrefix:photoNameStr];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",pngName]]contents:data attributes:nil];
//        NSString *filePath;
        
//        filePath = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath,pngName];
        
        [picker dismissViewControllerAnimated:nil completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.rTextView inserImageByImage:[UIImage imageWithData:data]];
//            [self  setPhotoIm:filePath data:data];
        }];
    }
}

#pragma mark -键盘监听
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [info [@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
         self.bottomTool.frame = CGRectMake(0, KHeight - keyboardSize.height-40, KWidth, 40);
    }];
}
- (void)keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [info [@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomTool.frame = CGRectMake(0, KHeight, KWidth, 40);
        [self.view endEditing:YES];
    }];
}

#pragma mark- get
- (UIView *)bottomTool{
    if (!_bottomTool) {
        _bottomTool = [[UIView alloc]initWithFrame:CGRectMake(0, KHeight , KWidth, 40)];
        
        _bottomTool.backgroundColor = [UIColor colorWithRed:250.0/256 green:250.0/256 blue:250.0/256 alpha:250.0/256];
        UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(12.5, 0, 55.0/2, 55.0/2)];
        [cameraBtn setImage:[UIImage imageNamed:@"拍照"] forState:UIControlStateNormal];
        [cameraBtn handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{
            
            [self gotoCamera];
        }];
        
        cameraBtn.center = CGPointMake(cameraBtn.center.x, _bottomTool.height/2);
        [_bottomTool addSubview:cameraBtn];
        UIButton *albumBtn = [[UIButton alloc]initWithFrame:CGRectMake(cameraBtn.right + 21, cameraBtn.top, 55.0/2, 55.0/2)];
        [albumBtn setImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
        [albumBtn handleClickEvent:UIControlEventTouchUpInside withClickBlick:^{

            [self gotoAlbumStepbefore];
        }];
        
        [_bottomTool addSubview:albumBtn];
        
        UIButton *keyBoardBtn = [[UIButton alloc]initWithFrame:CGRectMake(KWidth - 40, cameraBtn.frame.origin.y, cameraBtn.frame.size.width, cameraBtn.frame.size.height)];
        [keyBoardBtn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
        [keyBoardBtn addTarget:self action:@selector(endEditingTextView:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomTool addSubview:keyBoardBtn];

    }
    return _bottomTool;
}

- (UIImagePickerController*)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];;
        _picker.delegate = self;
        _picker.allowsEditing = YES;
    }
    return _picker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
