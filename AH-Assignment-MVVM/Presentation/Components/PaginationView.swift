//
//  PaginationView.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 08/07/2022.
//

import SnapKit
import UIKit

protocol PaginationViewDelegate: AnyObject {
    func goBack()
    func goForward()
}

class PaginationView: UIView {
    
    weak var delegate: PaginationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(paginationStackView)
        paginationStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Back"
        configuration.image = UIImage(systemName: "arrow.backward")
        configuration.imagePlacement = .leading
        let back = UIButton(configuration: configuration)
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return back
    }()
    
    private lazy var paginationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var forwardButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Next"
        configuration.image = UIImage(systemName: "arrow.forward")
        configuration.imagePlacement = .trailing
        let forward = UIButton(configuration: configuration)
        forward.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        return forward
    }()
    
    private lazy var paginationStackView: UIStackView = {
        let paginationStack = UIStackView()
        paginationStack.spacing = 10
        paginationStack.axis = .horizontal
        paginationStack.addArrangedSubview(backButton)
        paginationStack.addArrangedSubview(paginationLabel)
        paginationStack.addArrangedSubview(forwardButton)
        return paginationStack
    }()
    
    @objc
    private func goBack() {
        delegate?.goBack()
    }

    @objc
    private func goForward() {
        delegate?.goForward()
    }
    
    func updateBackTitle(_ backTitle: String) {
        backButton.configuration?.title = backTitle
    }
    
    func updateForwardTitle(_ forwardTitle: String) {
        forwardButton.configuration?.title = forwardTitle
    }
    
    func updateBackButtonState(isEnabled: Bool) {
        backButton.isEnabled = isEnabled
    }
    
    func updateForwardButtonState(isEnabled: Bool) {
        forwardButton.isEnabled = isEnabled
    }
    
    func updatePaginationLabel(_ text: String) {
        paginationLabel.text = text
    }
}
