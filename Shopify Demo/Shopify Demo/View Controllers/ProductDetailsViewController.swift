

import UIKit
import Intempt

private enum CellKind: Int {
    case header
    case details
}

protocol ProductDetailsDelegate: class {
    func changeEvent(status : Bool)
}

class ProductDetailsViewController: ParallaxViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var product: ProductViewModel!
    var delegate:ProductDetailsDelegate?
    private var imageViewController: ImageViewController!
    var isAddedToCart:Bool = false
    
    //  MARK: - Segue -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier! {
        case "ImageViewController":
            self.imageViewController = (segue.destination as! ImageViewController)
        default:
            break
        }
    }
    
    
    //  MARK: - View Lifecyle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Products", style: UIBarButtonItem.Style.done, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.registerTableCells()
        
        self.configureHeader()
        self.configureImageController()
    }
    
    private func registerTableCells() {
        self.tableView.register(ProductHeaderCell.self)
        self.tableView.register(ProductDetailsCell.self)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    private func configureHeader() {
        self.headerHeight = self.view.bounds.width * 0.5625 // 16:9 ratio
    }
    
    private func configureImageController() {
        
        self.imageViewController.activePageIndicatorColor   = self.view.tintColor.withAlphaComponent(0.8)
        self.imageViewController.inactivePageIndicatorColor = self.view.tintColor.withAlphaComponent(0.3)
        
        self.imageViewController.imageItems = self.product.images.items.map {
            ImageItem.url($0.url, placeholder: nil)
        }
    }
    
    //  MARK: - Actions -
    @IBAction func cartAction(_ sender: Any) {
        let cartController: CartNavigationController = self.storyboard!.instantiateViewController()
        self.navigationController!.present(cartController, animated: true, completion: nil)
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        delegate?.changeEvent(status: isAddedToCart)
        self.navigationController?.popViewController(animated: true)
        
    }
}



//  MARK: - ProductHeaderDelegate -

extension ProductDetailsViewController: ProductHeaderDelegate {
    
    func productHeader(_ cell: ProductHeaderCell, didAddToCart sender: Any) {
        let item = CartItem(product: self.product, variant: self.product.variants.items[0])
        CartController.shared.add(item)
        
        let arrProductBuy = NSMutableArray()
        let dictProductBuy = NSMutableDictionary()

        dictProductBuy.setValue(self.product.title, forKey: "productName")
        let price = self.product.variants.items.first?.price
        dictProductBuy.setValue(price, forKey: "amount")
        dictProductBuy.setValue(true, forKey: "successfulTransaction")
         
        arrProductBuy.add(dictProductBuy)
        print("Product added to carts: \(arrProductBuy)")
        /*IntemptTracker.track("Purchase", withProperties: arrProductBuy as? [Any]) { (status, result, error) in
            if(status) {
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
        IntemptTracker.track("Purchase", withProperties: arrProductBuy as? [Any]) { (status, result, error) in
            if(status) {
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        isAddedToCart = true
    }
}


//  MARK: - UITableViewDataSource -

extension ProductDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellKind(rawValue: indexPath.row)! {
        case .header:
            let cell = tableView.deque(ProductHeaderCell.self, configureFrom: self.product, at: indexPath)
            cell.delegate = self
            return cell
            
        case .details:
            return tableView.deque(ProductDetailsCell.self, configureFrom: self.product, at: indexPath)
        }
    }
}


//  MARK: - UITableViewDelegate -

extension ProductDetailsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateParallax()
    }
}


//  MARK: - Convenience -

private extension UITableView {
    
    func register<C>(_ cellType: C.Type) where C: UITableViewCell {
        let name = String(describing: cellType.self)
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func deque<M, C>(_ cellType: C.Type, configureFrom viewModel: M, at indexPath: IndexPath) -> C where M: ViewModel, C: UITableViewCell, C: ViewModelConfigurable, C.ViewModelType == M  {
        let name = String(describing: cellType.self)
        let cell = self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! C
        cell.configureFrom(viewModel)
        return cell
    }
}
