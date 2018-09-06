//
//  AmiibosViewController.swift
//  Amiibo
//
//  Created by Gustavo Campos on 8/27/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxSwift
import RxDataSources
import RxCocoa

class AmiibosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = 100
            tableView.register(UINib(nibName: "AmiiboTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        }
    }
    
    let searchBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
    }()
    
    private let datasource = RxTableViewSectionedReloadDataSource<AmiiboType>(configureCell:  { (datasource, tableview, indexpath, item) -> UITableViewCell in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexpath) as? AmiiboTableViewCell else {
            return UITableViewCell()
        }
        cell.amiibos.accept(item.items)
        return cell
    }, titleForHeaderInSection: { datasource, index in
        return datasource[index].type.name
    })
    
    private var amiiboType: BehaviorRelay<AmiiboType?> = BehaviorRelay(value: nil)
    
    private let viewModel: AmiiboViewModelType
    
    init(viewModel: AmiiboViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setRightBarButton(searchBarButton, animated: animated)
    }
    
    override func selectedAmiibo(_ parameter: Any) {
        guard let amiibo = parameter as? Amiibo else {
            return
        }
        let vc = DetailViewController(amiibo: amiibo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func binding() {
        viewModel
            .outputs
            .showTypes
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        searchBarButton.rx.tap.bind { [unowned self] in
            let viewController = AmiibosSearchViewController(viewModel: AmiiboSearchViewModel(reachability: try! DefaultReachabilityService()))
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true)
        }.disposed(by: disposeBag)
    }
}
