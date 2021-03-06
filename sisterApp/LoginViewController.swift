 
import UIKit
import Firebase

class LoginViewController: UIViewController {
  
    
  // MARK: Observer
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
        do {
          try Auth.auth().useUserAccessGroup("6T8ZJ7M7C9.com.example.group")
        } catch let error as NSError {
          print("Error changing user access group: %@", error)
        }
        
      // 1 observer added. Do the same in listVC to get current user info
      Auth.auth().addStateDidChangeListener() { auth, user in
        // 2
        if user != nil {
          // 3
          self.performSegue(withIdentifier: self.loginToList, sender: nil)
          self.textFieldLoginEmail.text = nil
          self.textFieldLoginPassword.text = nil
        }
      }
    }

    
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    guard
      let email = textFieldLoginEmail.text,
      let password = textFieldLoginPassword.text,
      email.count > 0,
      password.count > 0
      else {
        return
    }

    Auth.auth().signIn(withEmail: email, password: password) { user, error in
      if let error = error, user == nil {
        let alert = UIAlertController(title: "Sign In Failed",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
      }
    }

  }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
        // 1
        let emailField = alert.textFields![0]
        let passwordField = alert.textFields![1]

        // 2 Call createUser(withEmail:password:) on the default Firebase auth object passing the email and password.
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
          if error == nil {
            // 3 you still need to authenticate this new user
            Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
                               password: self.textFieldLoginPassword.text!)
          }
        }

    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
}
