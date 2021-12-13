

import UIKit
import MobileBuySDK
import PassKit

enum PaymentType {
    case applePay
    case webCheckout
}

protocol TotalsControllerDelegate: class {
    func totalsController(_ totalsController: TotalsViewController, didRequestPaymentWith type: PaymentType)
}

class TotalsViewController: UIViewController, LoginControllerDelegate {
    func loginControllerDidCancel(_ loginController: LoginViewController) {
        
    }
    
    func loginController(_ loginController: LoginViewController, didLoginWith email: String, passowrd: String) {
        self.webCheckoutAction(UIButton())
    }
    
    @IBOutlet private weak var subtotalTitleLabel: UILabel!
    @IBOutlet private weak var subtotalLabel: UILabel!
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet private weak var lblDeliveryAddress: UILabel!
    
    var addressModel:AddressModel?
    
    weak var delegate: TotalsControllerDelegate?
    
    var itemCount: Int = 0 {
        didSet {
            self.subtotalTitleLabel.text = "\(self.itemCount) Item\(itemCount == 1 ? "" : "s")"
        }
    }
    
    var subtotal: Decimal = 0.0 {
        didSet {
            self.subtotalLabel.text = Currency.stringFrom(self.subtotal)
        }
    }
    

    //  MARK: - View Lifecyle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPurchaseOptions()
    }
    @IBAction func addDeliveryAddress(){
        let coordinator: DeliveryAddressViewController = self.storyboard!.instantiateViewController()
        coordinator.completionHandler = { add in
            if let addrs = add{
                self.addressModel = addrs
                var compsnts = [String]()
                if let val = addrs.street{
                    compsnts.append("Steet# " + val)
                }
                if let val = addrs.house{
                    compsnts.append("House# " + val)
                }
                if let val = addrs.city{
                    compsnts.append("City# " + val)
                }
                if let val = addrs.state{
                    compsnts.append("State# " + val)
                }
                if let val = addrs.zipcode{
                    compsnts.append("Zip code# " + val)
                }
                self.lblDeliveryAddress.text = compsnts.joined(separator: ", ")
            }
        }
        self.present(coordinator, animated: true, completion: nil)
    }
    private func loadPurchaseOptions() {
        
        let webCheckout = RoundedButton(type: .system)
        webCheckout.backgroundColor = UIColor.applicationGreen
        webCheckout.addTarget(self, action: #selector(webCheckoutAction(_:)), for: .touchUpInside)
        webCheckout.setTitle("Checkout",  for: .normal)
        webCheckout.setTitleColor(.white, for: .normal)
        self.buttonStackView.addArrangedSubview(webCheckout)
        
//        if PKPaymentAuthorizationController.canMakePayments() {
//            let applePay = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
//            applePay.addTarget(self, action: #selector(applePayAction(_:)), for: .touchUpInside)
//            self.buttonStackView.addArrangedSubview(applePay)
//        }
    }
    
    //  MARK: - Actions -

    @objc func webCheckoutAction(_ sender: Any) {
     //   self.delegate?.totalsController(self, didRequestPaymentWith: .webCheckout)
        
        if UserSession.getUser() == nil{
            let alert = UIAlertController(title: "Login!", message: "Please login or create your account first.", preferredStyle: UIAlertController.Style.alert)
            
            let yesAction = UIAlertAction(title: "Login", style: .default) { action in
                UserSession.logoutUser()
                let coordinator: LoginViewController = self.storyboard!.instantiateViewController()
                coordinator.delegate = self
                self.present(coordinator, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else if addressModel == nil{
            let alert = UIAlertController(title: "Delivery Address!", message: "Please provide your delivery address.", preferredStyle: UIAlertController.Style.alert)
            
            let yesAction = UIAlertAction(title: "Add", style: .default) { action in
                self.addDeliveryAddress()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Order Created Successfully!", message: "Thank you very much for placing an order, our agent will soon contact you for the confirmation.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                for i in CartController.shared.items {
                    CartController.shared.removeAllQuantitiesFor(i)
                }
                
                self.dismiss(animated: true, completion: nil)
            }))
                  
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    @objc func applePayAction(_ sender: Any) {
        self.delegate?.totalsController(self, didRequestPaymentWith: .applePay)
    }
}
