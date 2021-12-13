import UIKit
import Intempt

protocol LoginControllerDelegate: class {
    func loginControllerDidCancel(_ loginController: LoginViewController)
    func loginController(_ loginController: LoginViewController, didLoginWith email: String, passowrd: String)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var topSegment: UISegmentedControl!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var signupButton: RoundedButton!
    @IBOutlet weak var signupPasswordField: UITextField!
    @IBOutlet weak var signupEmailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
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
    
    private var firstName: String {
        return self.firstNameField.text ?? ""
    }
    
    private var lastName: String {
        return self.lastNameField.text ?? ""
    }
    
    private var signUpEmail: String {
        return self.signupEmailField.text ?? ""
    }
    
    private var signupPassword: String {
        return self.signupPasswordField.text ?? ""
    }
    private var phone: String {
        return self.phoneField.text ?? ""
    }
    //  MARK: - View Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpView.isHidden = true
        self.title = "Login"
        self.updateLoginState()
        self.updateSignupState()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    //  MARK: - Updates -
    private func updateLoginState() {
        let isValid = !self.email.isEmpty && !self.password.isEmpty
        
        self.loginButton.isEnabled = isValid
        self.loginButton.alpha = isValid ? 1.0 : 0.5
    }
    private func updateSignupState() {
        let isValid = !self.firstName.isEmpty && !self.lastName.isEmpty && !self.signUpEmail.isEmpty && !self.signupPassword.isEmpty
        
        self.signupButton.isEnabled = isValid
        self.signupButton.alpha = isValid ? 1.0 : 0.5
    }
    
    @IBAction func accountSegmentControl(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            loginView.isHidden = false
            signUpView.isHidden = true
            self.title = "Login"
        }
        else
        {
            loginView.isHidden = true
            signUpView.isHidden = false
            self.title = "Signup"
        }
    }
    
}


//  MARK: - Actions -
extension LoginViewController {
    
    @IBAction private func textFieldValueDidChange(textField: UITextField) {
        self.updateLoginState()
        self.updateSignupState()
    }
    
    @IBAction private func loginAction(_ sender: UIButton) {
        let email = self.usernameField.text ?? ""
        let password = self.passwordField.text ?? ""
        if email.isValidEmail() == false{
            showAlert(title: "Hang On!", message: "Please provide a valid email address.", vc: self)
            return
        }
        let allUsers = UserSession.getAllUsers()
        var foundUser:UserModel?
        for item in allUsers{
            if item.email?.lowercased() == email.lowercased() && item.password == password{
                foundUser = item
            }
        }
        if (foundUser != nil){
            IntemptTracker.identify(email, withProperties: nil) { (status, result, error) in
                if(status) {
                    NSLog("Identify successful")
                    if let dictResult = result as? [String: Any] {
                        print(dictResult)
                    }
                    UserSession.saveUser(user: foundUser!)
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserDetails"), object: nil, userInfo: nil)
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            self.delegate?.loginController(self, didLoginWith: self.email, passowrd: self.password)
        }else{
            showAlert(title: "Oops!", message: "Invalid email address or password.", vc: self)
        }
    }
    @IBAction func signupBtnAction(_ sender: UIButton)
    {
        let email = self.signupEmailField.text ?? ""
        let fName = self.firstNameField.text ?? ""
        let phone = self.phoneField.text ?? ""
        let password = self.signupPasswordField.text ?? ""
        if email.isValidEmail() == false{
            showAlert(title: "Hang On!", message: "Please provide a valid email address.", vc: self)
            return
        }
        if fName.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please provide your name.", vc: self)
            return
        }
        if phone.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please provide your phone number.", vc: self)
            return
        }
        if password.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please set your password.", vc: self)
            return
        }
        if password.count < 6{
            showAlert(title: "Hang On!", message: "Password should be of minimum 6 characters.", vc: self)
            return
        }
        var foundUser:UserModel?
        var allUsers = UserSession.getAllUsers()
        for item in allUsers{
            if item.email?.lowercased() == email.lowercased(){
                foundUser = item
            }
        }
        if foundUser != nil{
            showAlert(title: "Oops!", message: "User with same email already exists. Please try login.", vc: self)
            return
        }else{
            IntemptTracker.identify(signUpEmail, withProperties: nil) { (status, result, error) in
                if(status) {
                    NSLog("Identify successful")
                    if let dictResult = result as? [String: Any] {
                        print(dictResult)
                    }
                    let user = UserModel()
                    user.email = self.signupEmailField.text ?? ""
                    user.fname = self.firstNameField.text ?? ""
                    user.lname = self.lastNameField.text ?? ""
                    user.phone = phone
                    user.password = password
                    UserSession.saveUser(user: user)
                    allUsers.append(user)
                    UserSession.saveNewUser(user: allUsers)
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserDetails"), object: nil, userInfo: nil)
                }
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            self.delegate?.loginController(self, didLoginWith: self.signUpEmail, passowrd: self.signupPassword)
        }
    }
    @IBAction private func cancelAction(_ sender: UIButton) {
        self.delegate?.loginControllerDidCancel(self)
    }
}
