//
//  ViewController.swift
//  Colm English Tech Test
//
//  Created by Colm English on 29/03/2022.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var cryptoTablview: UITableView!
    private var elementVM : [CoingeckoElement]?
    private var dataObserver:NSObjectProtocol?
    private var failObserver:NSObjectProtocol?
    
    private let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cryptoTablview.delegate = self
        cryptoTablview.dataSource = self
        cryptoTablview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateData(_:)), for: .valueChanged)

        
//        self.cryptoTablview.register(UITableViewCell.self, forCellReuseIdentifier: "CryptoTableCell")
        
        self.dataObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataUpdated, object: nil, queue: OperationQueue.main, using: { [weak self] (notification) in
            self?.updateViewFromModel()
        })
        
        self.failObserver = NotificationCenter.default.addObserver(forName: Notification.Name.dataFailed, object: nil, queue: OperationQueue.main, using: { [weak self] (notification) in
            self?.showFailMessage()
        })
        
        CryptoDataModel.getCryptoData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        if dataObserver != nil {
            NotificationCenter.default.removeObserver(dataObserver!)
        }
        if failObserver != nil {
            NotificationCenter.default.removeObserver(failObserver!)
        }
    }
    
    @objc private func updateData(_ sender: Any){
        CryptoDataModel.getCryptoData()
    }

    private func updateViewFromModel() {
        print("Data got \(CryptoDataModel.coinData.count)")
        cryptoTablview.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func showFailMessage() {
        print("Data failed")
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegue"
        {
            if let destinationVC = segue.destination as? DetailsViewController {
                let indexRow = cryptoTablview.indexPathForSelectedRow?.row
                cryptoTablview.deselectRow(at: cryptoTablview.indexPathForSelectedRow!, animated: true)
                destinationVC.index = indexRow ?? 0
            }
        }
    }
    
    
}



extension MainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CryptoDataModel.coinData.count
    }
}


extension MainViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CryptoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CryptoTableCell", for: indexPath) as! CryptoTableViewCell
        let currentElementVM = CryptoDataModel.coinData[indexPath.row]
        cell.element = currentElementVM
        
        cell.cellImageView.kf.setImage(with: URL(string: currentElementVM.image),
                                       placeholder: UIImage(contentsOfFile: "cryptoPlaceholder"))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
}

