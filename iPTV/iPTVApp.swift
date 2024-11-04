//
//  iPTVApp.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/24/24.
//

import SwiftUI

@main
struct iPTVApp: App {
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
