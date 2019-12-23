//
//  ViewController.swift
//  FaceAuthentication
//
//  Created by Jessica Jacob on 17/09/19.
//  Copyright © 2019 Jessica Jacob. All rights reserved.
//

import UIKit
import LocalAuthentication

/// The available states of being logged in or not.
enum AuthenticationState {
    
    case loggedin, loggedout
    
}


class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var faceIDLabel: UILabel!
    
    
    var context = LAContext()
    var state = AuthenticationState.loggedout {
        didSet {
            loginButton.isHighlighted = (state == .loggedin)  // The button text changes on highlight.
            stateView.backgroundColor = (state == .loggedin) ? .yellow : .red
            faceIDLabel.isHidden = (state == .loggedin) || (context.biometryType != .faceID)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authenticate()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // The biometryType, which affects this app's UI when state changes, is only meaningful
        //  after running canEvaluatePolicy. But make sure not to run this test from inside a
        //  policy evaluation callback (for example, don't put next line in the state's didSet
        //  method, which is triggered as a result of the state change made in the callback),
        //  because that might result in deadlock.
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        
    }
    
    @IBAction func tapButton(_ sender: Any) {
        authenticate()
    }
    
    func authenticate(){
        if state == .loggedin {
            state = .loggedout
        }
        else {
            //part 13
            context = LAContext()
            
            context.localizedCancelTitle = "cancel"
            //part 9
            // First check if we have the needed hardware support.`
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }
                    }
                    else {
                        print(error?.localizedDescription ?? "Can't evaluate policy")
                    }
                }
            }
        }
    }
}


