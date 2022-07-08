//
//  PaginationView.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 08/07/2022.
//

import SnapKit
import UIKit

protocol PaginationViewDelegate: AnyObject {
    func onBackAction()
    func onForwardAction()
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
        let backButton = UIButton(configuration: configuration)
        backButton.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var paginationLabel: UILabel = {
        let paginationLabel = UILabel()
        paginationLabel.font = .systemFont(ofSize: 14)
        paginationLabel.textColor = .black
        paginationLabel.numberOfLines = 1
        paginationLabel.adjustsFontSizeToFitWidth = true
        paginationLabel.minimumScaleFactor = 0.8
        return paginationLabel
    }()
    
    private lazy var forwardButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Next"
        configuration.image = UIImage(systemName: "arrow.forward")
        configuration.imagePlacement = .trailing
        let forwardButton = UIButton(configuration: configuration)
        forwardButton.addTarget(self, action: #selector(onForwardAction), for: .touchUpInside)
        return forwardButton
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
    private func onBackAction() {
        delegate?.onBackAction()
    }

    @objc
    private func onForwardAction() {
        delegate?.onForwardAction()
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
