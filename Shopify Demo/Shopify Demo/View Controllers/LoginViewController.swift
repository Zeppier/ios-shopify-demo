import UIKit
import Intempt

protocol LoginControllerDelegate: class {
    func loginControllerDidCancel(_ loginController: LoginViewController)
    func loginController(_ loginController: LoginViewController, didLoginWith email: String, passowrd: String)
}

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var loginButton:   UIButton!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    weak var delegate: LoginControllerDelegate?
    
    private var email: String {
        return self.usernameField.text ?? ""
    }
    
    private var password: String {
        return self.passwordField.text ?? ""
    }
    
    //  MARK: - View Lifecyle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLoginState()
    }
    
    //  MARK: - Updates -
    private func updateLoginState() {
        let isValid = !self.email.isEmpty && !self.password.isEmpty
        
        self.loginButton.isEnabled = isValid
        self.loginButton.alpha = isValid ? 1.0 : 0.5
    }
}


//  MARK: - Actions -
extension LoginViewController {
 
    @IBAction private func textFieldValueDidChange(textField: UITextField) {
        self.updateLoginState()
    }
    
    @IBAction private func loginAction(_ sender: UIButton) {
        /*IntemptTracker.identify(email, withProperties: nil) { (status, result, error) in
            if(status) {
                NSLog("identify successful")
                if let dictResult = result as? [String: Any] {
                    print(dictResult)
                }
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }*/
        IntemptTracker.identify(email, withProperties: nil) { (status, result, error) in
            if(status) {
                NSLog("identify successful")
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        self.delegate?.loginController(self, didLoginWith: self.email, passowrd: self.password)
    }
    
    @IBAction private func cancelAction(_ sender: UIButton) {
        self.delegate?.loginControllerDidCancel(self)
    }
}
