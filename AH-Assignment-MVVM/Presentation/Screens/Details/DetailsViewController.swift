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
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private lazy var messageView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return imageView
    }()
    
    private lazy var titleView: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.textColor = .black
        title.numberOfLines = 0
        title.textAlignment = .left
        return title
    }()
    
    private lazy var descriptionView: UILabel = {
        let description = UILabel()
        description.font = .systemFont(ofSize: 14)
        description.textColor = .black
        description.numberOfLines = 0
        description.textAlignment = .left
        return description
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(descriptionStackView)
        return scroll
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(titleView)
        stack.addArrangedSubview(descriptionView)
        return stack
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
            action: #selector(viewModel.backButtonAction)
        )
        navigationItem.setLeftBarButton(backButton, animated: false)
        imageView.kf.indicatorType = .activity
        view.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(loaderView)
        view.addSubview(messageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.horizontalEdges.equalTo(view).inset(15)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        messageView.snp.makeConstraints { make in
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
        descriptionStackView.isUserInteractionEnabled = false
    }
    
    func handleLoadedState() {
        loaderView.isHidden = true
        descriptionStackView.isUserInteractionEnabled = true
        titleView.text = viewModel.title
        descriptionView.text = viewModel.description
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
        messageView.text = error
        messageView.isHidden = false
        descriptionStackView.isHidden = true
        loaderView.isHidden = true
    }
}
