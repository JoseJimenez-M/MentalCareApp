//
//  PanicViewController.swift
//  TestAnalizer(JFL)
//
//  Created by english on 2025-04-03.
//

import UIKit

class PanicViewController: UIViewController {
    
    @IBAction func callEmergencyButtonPressed(_ sender: UIButton) {
           if let url = URL(string: "tel://9110") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url)
               }else {
                   print("No se puede realizar la llamada")
               }
           }
       }
    
    @IBAction func callYourTherapist(_ sender: UIButton){
           if let url = URL(string: "tel://4389398759") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url)
               }else {
                   print("No se puede realizar la llamada")
               }
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
