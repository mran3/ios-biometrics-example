//
//  ViewController.swift
//  BiometricExample
//
//  Created by Andres Acevedo on 03/07/2018.
//  Copyright © 2018 Andres Acevedo. All rights reserved.
//  Used https://gist.github.com/anonymous/ffbcf200b2ce470b487dbb494dcac2c1 as guide

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationWithTouchID()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        self.getTime() //We do the biometrics just as an example, clicking the button also fetchs the date time
    }
}

extension ViewController {
    
    func getTime(){
        let myTimeAPI = TimeAPI()
        
        myTimeAPI.getDateTime{(result) in
            switch result {
            case let .success(res):
//                print("Server Date: \(res.0)")
//                print("Server Time: \(res.1)")
                let serverDateTime = "\(res.0) \(res.1)"
                let localDateTime = FormatUtilities.toCurrentTimeZone(date: serverDateTime, format: "dd-MM-yyyy hh:mm:ss a", fromTimeZone: "GMT")
                
                DispatchQueue.main.async {
                    self.transitionToTimeDetailView(serverTime: serverDateTime, localizedTime:localDateTime)
                }
                //print (currentTimeZone)
                
            case let .failure(res):
                print(res)
            }
        }
    }
    
    func transitionToTimeDetailView(serverTime:String, localizedTime:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondaryVC") as? SecondaryVC;
        vc?.receivedServerTime = serverTime
        vc?.receivedLocalTime = localizedTime
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To enter a new world..."
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    self.getTime()
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.biometryLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.biometryNotAvailable.rawValue:
                message = "Biometry is not available on the device"
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Biometry is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
