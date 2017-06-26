//
//  ViewController.swift
//  Featureflow
//
//  Created by Max Mattini on 16/06/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import UIKit
import featureflowiossdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fromFile = false
        var apiKey = ""
       
        var configBuilder: FeatureflowConfig.Builder = FeatureflowConfig.builder()
        if fromFile {
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.path(forResource: "testData", ofType: "json") else {
                
                return
            }
            configBuilder = configBuilder.withDataFromPath(dataPath: path)
        } else {
            
            apiKey = "srv-env-cd07a68be3fa4030ae08cc168f180887"
            configBuilder = configBuilder.withBaseUri(baseUri: "https://app.featureflow.io") ///api/sdk/v1/features")
        }
        let config = configBuilder.build()
        
        let context = FeatureflowContext.keyedContext(key: "uniqueuserkey1")
            .withValue(key:"tier", value: "silver")
            .withValue(key:"age", value: 32)
            .withValue(key:"signup_date", date:Date())
            .withValue(key:"user_role", value: "standard_user")
            .withValue(key:"name", value: "John Smith")
            .withValue(key:"email", value: "oliver@featureflow.io")
            .build()
        
        let features = [  Feature(key:"something", variants:nil, failoverVariant: "red"),
                          Feature(key:"summary-dashboard", variants:nil, failoverVariant:Variant.off),
                          Feature(key:"feature1", variants:nil, failoverVariant:Variant.off),
                          Feature(key:"facebook-login", variants:nil, failoverVariant: "red"),
                          Feature(key:"standard-login", variants:nil, failoverVariant:Variant.off),
                          Feature(key:"example-feature", variants:nil, failoverVariant:Variant.off)]
        
        let featureflowClient =  FeatureflowClientBuilder(apiKey:apiKey)
            .withFeatures(features:features)
            .withConfig(config: config).build()
        
        
        featureflowClient.retrieveFeatureControl(){ (featureControls, error) in
            print("\(featureControls.keys.count) feature control read from file")
            
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

