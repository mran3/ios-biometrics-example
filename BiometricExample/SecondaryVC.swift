//
//  SecondaryVC.swift
//  BiometricExample
//
//  Created by Andres Acevedo on 12/07/2018.
//  Copyright © 2018 Andres Acevedo. All rights reserved.
//

import UIKit

class SecondaryVC: UIViewController {

    @IBOutlet weak var localizedTimeTxt: UITextField!
    @IBOutlet weak var serverTimeTxt: UITextField!
    var receivedServerTime:String = ""
    var receivedLocalTime:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTimeTxt.text = receivedLocalTime
        serverTimeTxt.text = receivedServerTime
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
