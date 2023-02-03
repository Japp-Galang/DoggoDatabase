//
//  ViewImagesController.m
//  Dogs
//
//  Created by Japp Galang on 2/1/23.
//

#import <Foundation/Foundation.h>
#import "ViewImagesController.h"
#import "DatabaseController.h"

@interface ViewImagesController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) DatabaseController *dbController;

@end

@implementation ViewImagesController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    CGFloat centerX = self.view.frame.size.width / 2;
    
    // Background
    self.view.backgroundColor = [UIColor whiteColor];
    // Top Shape background
    CGRect backShape = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/7);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:backShape ];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor systemBrownColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.layer.borderWidth = 1.0;
    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    backButton.layer.cornerRadius = 15.0;
    backButton.frame = CGRectMake(self.view.frame.size.width / 15, self.view.frame.size.height / 24 * 2, self.view.frame.size.width / 6, self.view.frame.size.height/20);
    backButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Add Image Button
    UIButton *addImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addImageButton setTitle:@"+" forState:UIControlStateNormal];
    addImageButton.layer.borderWidth = 1.0;
    addImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    addImageButton.layer.cornerRadius = 15.0;
    addImageButton.frame = CGRectMake(self.view.frame.size.width / 15 * 11.5, self.view.frame.size.height / 24 * 2, self.view.frame.size.width / 6, self.view.frame.size.height/20);
    addImageButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    [addImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageButton];
    
    // Title (dog's name)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 30 * 1.75, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    titleLabel.text = self.dogName;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/20];
    titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    // TEST TO SHOW FIRST IMAGE
    NSArray *dogData = [dbController returnDogImages:self.ident];
    
    
}



- (void)showImagePicker {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    
    
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    [dbController addImage:imageData ident:self.ident];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
