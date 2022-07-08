//
//  UICollectionView+Extension.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ type: T.Type, reuseIdentifier: String? = nil) {
        let typeName = String(describing: T.self)
        register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? typeName)
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let typeName = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: typeName, for: indexPath) as? T else {
            fatalError("Cannot dequeue cell with class \(typeName)")
        }
        return cell
    }
    
    func registerReusableView<T: UICollectionReusableView>(
        _ type: T.Type,
        reuseIdentifier: String? = nil,
        forSupplementaryViewOfKind: String
    ) {
        let typeName = String(describing: T.self)
        register(
            T.self,
            forSupplementaryViewOfKind: forSupplementaryViewOfKind,
            withReuseIdentifier: typeName
        )
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind: String,
        for indexPath: IndexPath
    ) -> T {
        let typeName = String(describing: T.self)
        guard let header = dequeueReusableSupplementaryView(
            ofKind: ofKind,
            withReuseIdentifier: typeName,
            for: indexPath
        ) as? T else {
            fatalError("Cannot dequeue supplementary view with class \(typeName)")
        }
        return header
    }
    
    func scrollToFirstItem() {
        scrollToItem(
            at: .init(row: 0, section: 0),
            at: .centeredVertically,
            animated: true
        )
    }
}
