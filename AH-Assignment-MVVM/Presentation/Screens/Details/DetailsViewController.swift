//
//  DetailsViewController.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 08/07/2022.
//

import Combine
import Kingfisher
import SnapKit
import UIKit

class DetailsViewController: UIViewController {

    private var viewModel: DetailsViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView(style: .large)
        loaderView.hidesWhenStopped = true
        return loaderView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 24)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        return descriptionLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(descriptionStackView)
        return scrollView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        return stackView
    }()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.didLoad()
    }
}

private extension DetailsViewController {
    
    func setupView() {
        view.backgroundColor = .white
        title = "Details"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: viewModel,
            action: #selector(viewModel.onBackButtonAction)
        )
        navigationItem.setLeftBarButton(backButton, animated: false)
        imageView.kf.indicatorType = .activity
        view.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(loaderView)
        view.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(15)
            make.horizontalEdges.equalTo(view).inset(15)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupBindings() {
        viewModel
            .statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.handleLoadingState()
                case .loaded:
                    self?.handleLoadedState()
                case .error(let error):
                    self?.handleErrorState(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func handleLoadingState() {
        loaderView.startAnimating()
        loaderView.isHidden = false
        imageView.isHidden = true
        scrollView.isHidden = true
    }
    
    func handleLoadedState() {
        loaderView.isHidden = true
        imageView.isHidden = false
        scrollView.isHidden = false
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.layoutIfNeeded()
        imageView.kf.setImage(
            with: viewModel.imageURL,
            options: [
                .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .onFailureImage(UIImage(systemName: "eye.trianglebadge.exclamationmark"))
            ]
        )
    }
    
    func handleErrorState(_ error: String) {
        messageLabel.text = error
        messageLabel.isHidden = false
        descriptionStackView.isHidden = true
        loaderView.isHidden = true
    }
}
