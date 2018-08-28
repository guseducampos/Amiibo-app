//
//  AmiiboTableViewCell.swift
//  Amiibo
//
//  Created by  LaptopGCampos on 8/23/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import RxCocoa
import RxSwift
import Kingfisher

final class AmiiboTableViewCell: UITableViewCell {
    
    var amiibos: BehaviorRelay<[Amiibo]> = BehaviorRelay(value: [])
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        willSet {
            newValue.register(UINib(nibName: "AmiiboCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
            newValue.delegate = self
            bind(colletionView: newValue)
        }
    }
    
    private func bind(colletionView: UICollectionView) {
        amiibos.bind(to: colletionView.rx.items(cellIdentifier: "cell",
                                                cellType: AmiiboCollectionViewCell.self)) { index, item , cell in
            cell.amiiboImageView.kf.setImage(with: URL(string: item.image))
            }.disposed(by: disposeBag)
        
        colletionView.rx.modelSelected(Amiibo.self).bind(onNext: { [weak self] in
            self?.selectedAmiibo($0)
        }).disposed(by: disposeBag)
    }
}


extension AmiiboTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
