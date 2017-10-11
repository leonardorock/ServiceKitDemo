//
//  AppDelegate.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/6/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupServiceConfiguration()
        return true
    }
    
    func setupServiceConfiguration() {
        let apiURL = URL(string: "https://api.github.com")!
        let configuration = ServiceConfiguration(url: apiURL, headers: [:], resultsKey: nil)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let modelResponseHandler = ModelResponseHandler(decoder: decoder)
        Service.shared.configuration = configuration
        Service.shared.responseHandlerDelegate = modelResponseHandler
    }

}

