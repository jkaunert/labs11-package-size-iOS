//
//  AuthViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@objcMembers
class AuthViewController: UITableViewController, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

    }
    
    
    func googleSigninButtonTapped(sender: UIButton!) {
        print("googleSigninButton tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
        let googleSigninButton = GIDSignInButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        googleSigninButton.style = .wide
        googleSigninButton.colorScheme = .dark
        googleSigninButton.addTarget(self, action: #selector(googleSigninButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(googleSigninButton)
    }
    
}
