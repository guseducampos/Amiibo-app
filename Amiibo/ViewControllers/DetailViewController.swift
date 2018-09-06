//
//  DetailViewController.swift
//  Amiibo
//
//  Created by Gustavo Campos on 8/28/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var serieNameLabel: UILabel!
    
    @IBOutlet weak var amiiboNameLabel: UILabel!
    
    @IBOutlet weak var gameSerieLabel: UILabel!
    
    @IBOutlet weak var amiiboTypeLabel: UILabel!
    
    @IBOutlet weak var amiiboImage: UIImageView!
    
    private let amiibo: Amiibo
    
    init(amiibo: Amiibo) {
        self.amiibo = amiibo
        super.init(nibName: "DetailViewController", bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serieNameLabel.text = amiibo.amiiboSeries
        amiiboNameLabel.text = amiibo.character
        gameSerieLabel.text = amiibo.gameSeries
        amiiboTypeLabel.text = amiibo.type
        amiiboImage.kf.setImage(with: URL(string: amiibo.image))
    }
}
