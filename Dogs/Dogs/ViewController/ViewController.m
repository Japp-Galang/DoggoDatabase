//
//  ViewController.m
//  Dogs
//
//  Created by Japp Galang on 1/28/23.
//

#import "ViewController.h"
#import "DatabaseController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat centerX = self.view.frame.size.width / 2;
    
    // Background
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect backShape = CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height / 20 * 1.5, self.view.frame.size.width / 2, self.view.frame.size.height/10);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:backShape cornerRadius:20];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor systemBrownColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height / 20 * 1.5, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    titleLabel.text = @"Doggos";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/20];
    titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    // Button for Add Dog
    UIButton *addDoggoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addDoggoButton setTitle:@"Add Dog" forState:UIControlStateNormal];
    addDoggoButton.layer.borderWidth = 2.0;
    addDoggoButton.layer.borderColor = [UIColor systemBrownColor].CGColor;
    addDoggoButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    addDoggoButton.layer.cornerRadius = 15.0;
    addDoggoButton.frame = CGRectMake(100, self.view.frame.size.height / 4, self.view.frame.size.width / 2.5 , self.view.frame.size.height/16);
    addDoggoButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    [addDoggoButton setTitleColor:[UIColor systemBrownColor] forState:UIControlStateNormal];
    addDoggoButton.center = CGPointMake(centerX, addDoggoButton.center.y);
    [addDoggoButton addTarget:self action:@selector(goToAddDoggoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addDoggoButton];
    
    
    // Button for View/Update
    UIButton *viewUpdateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [viewUpdateButton setTitle:@"View/Update" forState:UIControlStateNormal];
    viewUpdateButton.layer.borderWidth = 2.0;
    viewUpdateButton.layer.borderColor = [UIColor systemBrownColor].CGColor;
    addDoggoButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    viewUpdateButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
    viewUpdateButton.layer.cornerRadius = 15.0;
    viewUpdateButton.frame = CGRectMake(100, self.view.frame.size.height / 8 * 3, self.view.frame.size.width / 2.5, self.view.frame.size.height/16);
    viewUpdateButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    [viewUpdateButton setTitleColor:[UIColor systemBrownColor] forState:UIControlStateNormal];
    viewUpdateButton.center = CGPointMake(centerX, viewUpdateButton.center.y);
    [viewUpdateButton addTarget:self action:@selector(goToUpdateView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewUpdateButton];
    
    

    
}

- (IBAction)goToAddDoggoView:(id)sender
{
    self.addDoggoController = [[AddDoggoController alloc] init];
    [self presentViewController:self.addDoggoController animated:YES completion:nil];
    
}

- (IBAction)goToUpdateView:(id)sender
{
    self.updateController = [[ViewUpdateController alloc] init];
    [self presentViewController:self.updateController animated:YES completion:nil];
}

- (IBAction)showItems:(id)sender
{
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    NSArray *dogs = [dbController getAllDogs];
    for (NSString *element in dogs) {
        NSLog(@"%@", element);
    }
     
    
    
    
}

@end
