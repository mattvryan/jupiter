//
//  JupiterComputeImageViewController.m
//  Jupiter
//
//  Created by Matt Ryan on 8/31/13.
//  Copyright (c) 2013 Seventeen Stones. All rights reserved.
//

#import <AWSRuntime/AWSRuntime.h>
#import <AWSEC2/AWSEC2.h>

#import "ComputeImageVC.h"

@interface ComputeImageVC ()

@property (strong, nonatomic) AmazonCredentials * credentials;

@end

@implementation ComputeImageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // TODO: Remove hard-coded access key and secret key
    //self.credentials.accessKey = @"AKIAIX5QPZSJA5AS5GDQ";
    //self.credentials.secretKey = @"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";
    AmazonEC2Client* ec2Client = [[AmazonEC2Client alloc]
                                  initWithAccessKey:@"AKIAIX5QPZSJA5AS5GDQ"
                                  withSecretKey:@"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"];
    EC2DescribeImagesRequest* req = [[EC2DescribeImagesRequest alloc] init];
    [req addFilter:[[EC2Filter alloc] initWithName:@"owner-alias"
                                         andValues:[[NSMutableArray alloc]
                                                    initWithObjects:@"amazon", nil]]];
    EC2DescribeImagesResponse* resp = [ec2Client describeImages:req];
    NSMutableArray * images = resp.images;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
