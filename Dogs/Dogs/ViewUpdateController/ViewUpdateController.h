//
//  ViewUpdateController.h
//  Dogs
//
//  Created by Japp Galang on 1/28/23.
//
#import <UIKit/UIKit.h>


@interface ViewUpdateController : UIViewController <UITableViewDelegate, UITableViewDataSource>


- (void)viewDidLoad;
- (IBAction)back:(id)sender;
- (void)updateValues;

@end



