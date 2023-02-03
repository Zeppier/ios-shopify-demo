//
//  MyAddressesViewController.swift
//  Intempt eCommerce Store
//
//  Created by MacBook on 03/02/2023.
//  Copyright © 2023 Intempt. All rights reserved.
//

import UIKit

class MyAddressesViewController: UIViewController {

    @IBOutlet weak var viewNoAddress: UIView!
    @IBOutlet weak var tableViewList: UITableView!
    var completionHandler:((AddressModel?)->Void)?
    var datasource = [AddressModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datasource = UserSession.getAllAddresses()
        if datasource.isEmpty{
            viewNoAddress.isHidden = false
        }else{
            viewNoAddress.isHidden = true
        }
        tableViewList.dataSource = self
        tableViewList.delegate = self
    }


    @IBAction func backPressed(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addNewAddress(){
        let coordinator: DeliveryAddressViewController = self.storyboard!.instantiateViewController()
        coordinator.completionHandler = { add in
            if let addrs = add{
                _ = self.completionHandler?(addrs)
                self.dismiss(animated: false)
            }
        }
        self.present(coordinator, animated: true, completion: nil)
    }
}

//  MARK: - UITableViewDataSource -

extension MyAddressesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryAddressTableViewCell", for: indexPath) as! DeliveryAddressTableViewCell
        let addrs = datasource[indexPath.row]
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
        cell.lblAddress.text = compsnts.joined(separator: ", ")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            tableView.beginUpdates()
            
            self.datasource.remove(at: indexPath.row)
            UserSession.saveNewAdress(obj: self.datasource)
            
            if datasource.isEmpty{
                viewNoAddress.isHidden = false
            }else{
                viewNoAddress.isHidden = true
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        default:
            break
        }
    }
}


//  MARK: - UITableViewDelegate -

extension MyAddressesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = self.completionHandler?(datasource[indexPath.row])
        self.dismiss(animated: false)
    }
   
}
