//
//  DetailViewController.h
//  Ex6
//
//  Created by Xurxo Méndez Pérez on 25/12/13.
//  Copyright (c) 2013 SmartGalApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) User* user;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *surnameLabel;
@end
