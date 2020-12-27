//
//  ViewController.swift
//  sisterApp
//
//  Created by Engin KUK on 26.12.2020.
//

import UIKit
import Firebase

class ViewController: UIViewController {
 
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let user = Auth.auth().currentUser?.displayName
        
        title = user
    }

    func signOut() {
  
          do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
          } catch (let error) {
            print("Auth sign out failed: \(error)")
          }
         
    }

}

