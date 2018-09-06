//
//  AmiibosSearchViewController.swift
//  Amiibo
//
//  Created by Gustavo Campos on 8/28/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AmiibosSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var buttonClose: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: AmiiboSearchViewModelType
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: AmiiboSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: "AmiibosSearchViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        binding()
    }
    
    private func binding() {
        
        searchBar.rx.text.bind {[unowned self] text in
            guard let text = text, !text.isEmpty else {
                return
            }
            self.viewModel.input.searchAmiibos(text)
            }.disposed(by: disposeBag)
        
        viewModel.output.showAmiibos.bind(to: tableView.rx.items(cellIdentifier: "cell")) { index, item, cell in
            cell.textLabel?.text = item.character
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Amiibo.self).bind {[unowned self] amiibo in
            let vc = DetailViewController(amiibo: amiibo)
            self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        buttonClose.rx.tap.bind { [unowned self] in
            self.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
