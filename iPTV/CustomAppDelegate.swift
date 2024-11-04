//
//  CustomAppDelegate.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/1/24.
//

import UIKit
import GoogleCast

class CustomAppDelegate: NSObject, UIApplicationDelegate, GCKSessionManagerListener {
    private let receiverAppID = kGCKDefaultMediaReceiverApplicationID
    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            let discoveryCriteria = GCKDiscoveryCriteria(applicationID: receiverAppID)
            let options = GCKCastOptions(discoveryCriteria: discoveryCriteria)
            GCKCastContext.setSharedInstanceWith(options)
            
            // Add session listener to monitor cast connection status
            GCKCastContext.sharedInstance().sessionManager.add(self)
            
            return true
        }
    
    // Monitor session start
       func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
           print("Cast session started")
           // Add any custom actions here
       }

       // Monitor session end
       func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
           print("Cast session ended")
           // Add any custom actions here
       }
}
