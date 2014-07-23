//
//  TrackEatingViewController.h
//  quinoa
//
//  Created by Chirag Davé on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackEatingViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIView *imagePreviewContainer;

@property (strong, nonatomic) NSData *imageData;

- (IBAction)textFieldDismiss:(id)sender;

@end
