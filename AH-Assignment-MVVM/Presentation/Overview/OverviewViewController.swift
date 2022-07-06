//
//  OverviewViewController.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import UIKit

class OverviewViewController: UIViewController {
    
    private var viewModel: OverviewViewModel
    
    init(viewModel: OverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
