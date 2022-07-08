//
//  OverviewViewController.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Combine
import SnapKit
import UIKit

class OverviewViewController: UIViewController {
    
    private let numberOfCellsInRow: CGFloat = 3
    private let cellInteritemSpacing: CGFloat = 10
    private let sectionHorizontalSpacing: CGFloat = 10
    private let paginationViewHeight: CGFloat = 40
    
    private var viewModel: OverviewViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var paginationView: PaginationView = {
        let paginationView = PaginationView()
        paginationView.delegate = self
        paginationView.backgroundColor = .lightGray.withAlphaComponent(0.8)
        paginationView.layer.cornerRadius = 5
        return paginationView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 20,
            left: sectionHorizontalSpacing,
            bottom: 10,
            right: sectionHorizontalSpacing
        )
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellInteritemSpacing
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset.bottom = paginationViewHeight
        collectionView.register(OverviewCollectionViewCell.self)
        collectionView.registerReusableView(
            OverviewCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        return collectionView
    }()
    
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
    
    init(viewModel: OverviewViewModel) {
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

private extension OverviewViewController {
    
    func setupView() {
        view.backgroundColor = .white
        title = "Overview"
        collectionView.delegate = self
        collectionView.dataSource = self
        paginationView.isHidden = true
        view.addSubview(collectionView)
        view.addSubview(paginationView)
        view.addSubview(loaderView)
        view.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        paginationView.snp.makeConstraints { make in
            make.height.equalTo(paginationViewHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
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
                case .empty:
                    self?.handleEmptyState()
                case .error(let error):
                    self?.handleErrorState(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func handleLoadingState() {
        loaderView.startAnimating()
        loaderView.isHidden = false
        messageLabel.isHidden = true
        collectionView.isUserInteractionEnabled = false
    }
    
    func handleLoadedState() {
        collectionView.reloadData()
        collectionView.scrollToFirstItem()
        collectionView.isUserInteractionEnabled = true
        collectionView.isHidden = false
        paginationView.isHidden = false
        loaderView.isHidden = true
        messageLabel.isHidden = true
        paginationView.updateBackButtonState(isEnabled: viewModel.isBackPaginationAvailable)
        paginationView.updateForwardButtonState(isEnabled: viewModel.isForwardPaginationAvailable)
        paginationView.updatePaginationLabel(viewModel.paginationLabelText)
    }
    
    func handleEmptyState() {
        messageLabel.text = "No Art objects available!"
        messageLabel.isHidden = false
        collectionView.isHidden = true
        loaderView.isHidden = true
        paginationView.isHidden = true
    }
    
    func handleErrorState(_ error: String) {
        messageLabel.text = error
        messageLabel.isHidden = false
        collectionView.isHidden = true
        loaderView.isHidden = true
        paginationView.isHidden = true
    }
}

extension OverviewViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView: OverviewCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            let sectionTitle = viewModel.titleForSection(indexPath.section)
            headerView.setup(with: sectionTitle)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OverviewCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let cellModel = viewModel.cellModel(at: indexPath)
        cell.setup(with: cellModel)
        return cell
    }
}

extension OverviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension OverviewViewController : UICollectionViewDelegateFlowLayout{

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let horizontalSpacing = sectionHorizontalSpacing * 2
        let rowsInteritemSpacing = cellInteritemSpacing * (numberOfCellsInRow - 1)
        let widthHeight = (collectionViewWidth - horizontalSpacing - rowsInteritemSpacing) / numberOfCellsInRow
        return CGSize(width: widthHeight, height: widthHeight)
    }
}

extension OverviewViewController: PaginationViewDelegate {
    
    func onBackAction() {
        viewModel.onBackAction()
    }

    func onForwardAction() {
        viewModel.onForwardAction()
    }
}
