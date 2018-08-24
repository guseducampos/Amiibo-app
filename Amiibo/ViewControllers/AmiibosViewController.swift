//
//  AmiibosViewController.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import UIKit
import RxDataSources

class AmiibosViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints =  false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()
    
    let datasource = RxTableViewSectionedReloadDataSource<AmiiboType>(configureCell:  { (datasource, tableview, indexpath, item) -> UITableViewCell in
      //  guard let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexpath)
        return UITableViewCell()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
    
    }

    func addConstraints() {
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    }
}
