//
//  ViewController.swift
//  WhiteLabel
//
//  Created by Alexander Givens on 07/28/2016.
//  Copyright (c) 2016 Alexander Givens. All rights reserved.
//

import UIKit
import RestKit
import WhiteLabel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureRestKit() {
        
        // initialize AFRKHTTPClient
        let baseURL = NSURL(string: "https://beta.whitelabel.cool/api")
        let client = AFRKHTTPClient(baseURL: baseURL)
        
        // initialize RestKit
        let objectManager = RKObjectManager(HTTPClient: client)
        
        // setup object mappings
//        let labelMapping = RKObjectMapping(forClass: Label.class)
    }

}

/*

- (void)configureRestKit
    {
        // initialize AFNetworking HTTPClient
        NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        
        // initialize RestKit
        RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
        
        // setup object mappings
        RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
        [venueMapping addAttributeMappingsFromArray:@[@"name"]];
        
        // register mappings with the provider using a response descriptor
        RKResponseDescriptor *responseDescriptor =
        [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
        method:RKRequestMethodGET
        pathPattern:@"/v2/venues/search"
        keyPath:@"response.venues"
        statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [objectManager addResponseDescriptor:responseDescriptor];
}
 
 */