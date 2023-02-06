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

@property (nonatomic) CGFloat imageWidth;
@property (nonatomic) CGFloat imageHeight;

@property (nonatomic, strong) UIImage* currentImage;
@property (nonatomic, strong) UIImageView* currentImageView;
@property (nonatomic, strong) UIButton* previousButton;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) UIButton* deleteButton;

@property (nonatomic) NSInteger imageCount;
@property (nonatomic) NSInteger lastImageIndex;
@property (nonatomic) NSInteger selectedImageIndex;

@property (nonatomic) NSArray* dogData;
@end



@implementation ViewImagesController

- (instancetype)init
{
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat centerX = screenWidth / 2;
    
    
    // Background
    self.view.backgroundColor = [UIColor whiteColor];
    // Top Shape background
    CGRect backShape = CGRectMake(0, 0, screenWidth, screenHeight/7);
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
    backButton.frame = CGRectMake(screenWidth / 15, screenHeight / 24 * 2, screenWidth / 6, self.view.frame.size.height/20);
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
    addImageButton.frame = CGRectMake(screenWidth / 15 * 11.5, screenHeight / 24 * 2, screenWidth / 6, screenHeight/20);
    addImageButton.titleLabel.font = [UIFont systemFontOfSize:screenHeight/40];
    [addImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageButton];
    
    // Title (dog's name)
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight / 30 * 1.75, screenWidth / 2,  screenHeight/10)];
    titleLabel.text = self.dogName;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:screenHeight/20];
    titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    // Loads images of the dog selected and checks if there are any.
    self.dogData = [dbController returnDogImages:self.ident];
    NSLog(@"%@", self.dogData);
    self.imageCount = [self.dogData count];
    NSLog(@"%ld", (long)self.imageCount);
    
    if (self.imageCount == 0){
        UILabel *noImagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight / 30 * 4, screenWidth,  screenHeight/10)];
        noImagesLabel.text = @"No images for this dog";
        noImagesLabel.textColor = [UIColor grayColor];
        noImagesLabel.font = [UIFont systemFontOfSize:screenHeight/40];
        UIFontDescriptor *fontDescriptor = [noImagesLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        noImagesLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:noImagesLabel.font.pointSize];
        noImagesLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noImagesLabel];
    }
    else{
        UIImage *image = [UIImage imageWithData:self.dogData[self.selectedImageIndex][@"imageData"]];
        self.currentImageView = [[UIImageView alloc] initWithImage:image];
        [self setCorrectImageSize:self.currentImageView.frame.size.width height:self.currentImageView.frame.size.height];
        self.currentImageView.frame = CGRectMake(0, self.view.frame.size.height / 7 * 1.01, self.imageWidth, self.imageHeight);
        self.currentImageView.center = CGPointMake(centerX, self.currentImageView.center.y);
        [self.view addSubview:self.currentImageView];
        
        self.lastImageIndex = self.imageCount - 1;
        self.selectedImageIndex = 0;
        
        [self showPhotoNavigator]; // Initializes and shows previousButton, deleteButton, and nextButton
    }
}




/*
 sets the correct width and height of the image to fit to screen well
 */

- (void)setCorrectImageSize:(CGFloat)width height:(CGFloat)height
{
    CGFloat maxImageHeight = (self.view.frame.size.height / 10 * 8.1) - (self.view.frame.size.height / 7 * 1.01);
    CGFloat ratioCheck = maxImageHeight / self.view.frame.size.width;
    CGFloat imageRatio = height / width;
    
    NSLog(@"Checking if imageRatio: %f is greater than ratioCheck %f", imageRatio, ratioCheck);
    if(imageRatio > ratioCheck){
        CGFloat factor = maxImageHeight / height;
        self.imageHeight = maxImageHeight;
        self.imageWidth = width * factor;
        NSLog(@"imageRatio is greater than ratioCheck");
    }
    else{
        CGFloat factor = self.view.frame.size.width / width;
        self.imageWidth = self.view.frame.size.width;
        self.imageHeight = height * factor;
        NSLog(@"imageRatio is less than ratioCheck");
    }
}



/*
 Changes the image to the previous image
 Unavailable action if selector is all the way to the left (selectedImageIndex = 0)
 */
- (IBAction)goPrevious:(id)sender
{
    CGFloat centerX = self.view.frame.size.width / 2;
    
    self.selectedImageIndex = self.selectedImageIndex - 1;
    if (self.selectedImageIndex == 0){
        self.previousButton.layer.backgroundColor = [UIColor grayColor].CGColor;
        self.previousButton.userInteractionEnabled = NO;
    }
    
    self.nextButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
    self.nextButton.userInteractionEnabled = YES;
    
    // Reloads previous image to view
    UIImage *image = [UIImage imageWithData:self.dogData[self.selectedImageIndex][@"imageData"]];
    [self.currentImageView removeFromSuperview]; // Deloads previous image
    self.currentImageView = [[UIImageView alloc] initWithImage:image];
    [self setCorrectImageSize:self.currentImageView.frame.size.width height:self.currentImageView.frame.size.height];
    self.currentImageView.frame = CGRectMake(0, self.view.frame.size.height / 7 * 1.01, self.imageWidth, self.imageHeight);
    self.currentImageView.center = CGPointMake(centerX, self.currentImageView.center.y);
    [self.view addSubview:self.currentImageView];
     
}



/*
 Changes the image to the next image
 Unavailable action if selector is all the way to the right (selectedImageIndex = lastImageIndex)
 */
- (IBAction)goNext:(id)sender
{
    CGFloat centerX = self.view.frame.size.width / 2;
    
    self.selectedImageIndex = self.selectedImageIndex + 1;
    if (self.selectedImageIndex == self.lastImageIndex){
        self.nextButton.layer.backgroundColor = [UIColor grayColor].CGColor;
        self.nextButton.userInteractionEnabled = NO;
    }

    self.previousButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
    self.previousButton.userInteractionEnabled = YES;
    
    // Reloads next image to view
    UIImage *image = [UIImage imageWithData:self.dogData[self.selectedImageIndex][@"imageData"]];
    [self.currentImageView removeFromSuperview]; // Deloads previous image
    self.currentImageView = [[UIImageView alloc] initWithImage:image];
    [self setCorrectImageSize:self.currentImageView.frame.size.width height:self.currentImageView.frame.size.height];
    self.currentImageView.frame = CGRectMake(0, self.view.frame.size.height / 7 * 1.01, self.imageWidth, self.imageHeight);
    self.currentImageView.center = CGPointMake(centerX, self.currentImageView.center.y);
    [self.view addSubview:self.currentImageView];
}



/*
 Deletes current image
 */
- (IBAction)deleteImage:(id)sender
{
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat centerX = screenWidth / 2;
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    [self.currentImageView removeFromSuperview]; // Deloads previous image
    
    [dbController deleteRowFromImage:self.dogData[self.selectedImageIndex][@"imageID"]];
    self.dogData = [dbController returnDogImages:self.ident];
    self.imageCount = self.imageCount - 1;
    self.selectedImageIndex = 0;
    self.lastImageIndex = self.imageCount - 1;
    
    // Resets view if there are no images, else resets viewing image to the first image
    if (self.imageCount == 0){
        UILabel *noImagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight / 30 * 4, screenWidth,  screenHeight/10)];
        noImagesLabel.text = @"No images for this dog";
        noImagesLabel.textColor = [UIColor grayColor];
        noImagesLabel.font = [UIFont systemFontOfSize:screenHeight/40];
        UIFontDescriptor *fontDescriptor = [noImagesLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        noImagesLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:noImagesLabel.font.pointSize];
        noImagesLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:noImagesLabel];
        [self.previousButton removeFromSuperview];
        [self.nextButton removeFromSuperview];
        [self.deleteButton removeFromSuperview];
    } else {
        // Loads First Image
        self.currentImage = [UIImage imageWithData:self.dogData[0][@"imageData"]];
        self.currentImageView = [[UIImageView alloc] initWithImage:self.currentImage];
        [self setCorrectImageSize:self.currentImageView.frame.size.width height:self.currentImageView.frame.size.height];
        [self setCorrectImageSize:self.currentImageView.frame.size.width height:self.currentImageView.frame.size.height];
        self.currentImageView.frame = CGRectMake(0, self.view.frame.size.height / 7 * 1.01, self.imageWidth, self.imageHeight);
        self.currentImageView.center = CGPointMake(centerX, self.currentImageView.center.y);
        [self.view addSubview:self.currentImageView];
    }
    [self checkShouldAllowButtonClick];
        
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
    
    // Reloads images of the dog
    self.dogData = [dbController returnDogImages:self.ident];
    self.imageCount = [self.dogData count];
    self.lastImageIndex = self.imageCount - 1;
    self.selectedImageIndex = self.lastImageIndex;
    NSLog(@"%@", self.dogData);
    
    // Laods the newly added image to view
    self.selectedImageIndex = self.lastImageIndex;
    UIImage *image = [UIImage imageWithData:self.dogData[self.selectedImageIndex][@"imageData"]];
    [self.currentImageView removeFromSuperview]; // Deloads previous image
    self.currentImageView = [[UIImageView alloc] initWithImage:image];
    [self setCorrectImageSize:self.currentImageView.frame.size.width height:self.currentImageView.frame.size.height];
    self.currentImageView.frame = CGRectMake(0, self.view.frame.size.height / 7 * 1.01, self.imageWidth, self.imageHeight);
    self.currentImageView.center = CGPointMake(self.view.frame.size.width / 2, self.currentImageView.center.y);
    
    [self.view addSubview:self.currentImageView];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self showPhotoNavigator];
    
    // Updates image selector arrows to condition of being in the last image selection (since we are adding the image to the end
    [self checkShouldAllowButtonClick];
}



/*
 Shows UI (previousButton, nextButton, deleteButton
 */
- (void)showPhotoNavigator
{
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat centerX = screenWidth / 2;
    
    // Button to go to previous photo
    self.previousButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.previousButton setTitle:@"←" forState:UIControlStateNormal];
    self.previousButton.layer.borderWidth = 1.0;
    self.previousButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.previousButton.frame = CGRectMake(0, screenHeight / 10 * 8.1, screenWidth / 10 * 4, screenHeight / 10);
    self.previousButton.titleLabel.font = [UIFont systemFontOfSize:screenHeight / 30];
    self.previousButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    [self.previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.previousButton.userInteractionEnabled = NO;
    [self.previousButton addTarget:self action:@selector(goPrevious:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.previousButton];
    
    // Button to delete the current selected image
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.deleteButton setTitle:@"🗑️" forState:UIControlStateNormal];
    self.deleteButton.layer.borderWidth = 1.0;
    self.deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deleteButton.frame = CGRectMake(screenWidth / 10 * 4, screenHeight / 10 * 8.1, screenWidth / 10 * 2, screenHeight / 10);
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:screenHeight / 30];
    self.deleteButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteButton.layer.backgroundColor = [UIColor systemRedColor].CGColor;
    [self.deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteButton];
    
    // Button to go to next photo
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextButton setTitle:@"→" forState:UIControlStateNormal];
    self.nextButton.layer.borderWidth = 1.0;
    self.nextButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nextButton.frame = CGRectMake(screenWidth / 10 * 6, screenHeight / 10 * 8.1, screenWidth / 10 * 4, screenHeight / 10);
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:screenHeight / 30];
    self.nextButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //checks if theres another image, grays out nextButton if there is not:
    if (self.selectedImageIndex == self.lastImageIndex){
        self.nextButton.userInteractionEnabled = NO;
        self.nextButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    } else {
        self.nextButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
    }
    [self.nextButton addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
}



- (void) checkShouldAllowButtonClick
{
    // Sanity check for previousButton
    if (self.selectedImageIndex == 0) {
        self.previousButton.layer.backgroundColor = [UIColor grayColor].CGColor;
        self.previousButton.userInteractionEnabled = NO;
    } else {
        self.previousButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
        self.previousButton.userInteractionEnabled = YES;
    }
    
    // Sanity check for nextButton
    if (self.selectedImageIndex == self.lastImageIndex) {
        self.nextButton.layer.backgroundColor = [UIColor grayColor].CGColor;
        self.nextButton.userInteractionEnabled = NO;
    } else {
        self.nextButton.layer.backgroundColor = [UIColor systemBrownColor].CGColor;
        self.nextButton.userInteractionEnabled = YES;
    }
}



-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
