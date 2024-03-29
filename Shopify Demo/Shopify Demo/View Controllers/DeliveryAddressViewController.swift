//
//  DeliveryAddressViewController.swift
//  Shopify Demo
//
//  Created by MacBook on 13/12/2021.
//  Copyright © 2021 Intempt. All rights reserved.
//

import UIKit

class DeliveryAddressViewController: UIViewController {

    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var tfHouse: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfZipcode: UITextField!
    var completionHandler:((AddressModel?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    @IBAction func backPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(){
        
        let street = self.tfStreet.text ?? ""
        let house = self.tfHouse.text ?? ""
        let city = self.tfCity.text ?? ""
        let state = self.tfState.text ?? ""
        let zipCode = self.tfZipcode.text ?? ""
        if street.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please add street number.", vc: self)
            return
        }
        if house.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please add house number.", vc: self)
            return
        }
        if city.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please add city.", vc: self)
            return
        }
        if state.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please add state.", vc: self)
            return
        }
        if zipCode.isEmpty == true{
            showAlert(title: "Hang On!", message: "Please add zip code.", vc: self)
            return
        }
        let address = AddressModel()
        address.city = city
        address.house = house
        address.street = street
        address.state = state
        address.zipcode = zipCode
        self.dismiss(animated: false, completion: nil)
        self.completionHandler?(address)
    }

}
