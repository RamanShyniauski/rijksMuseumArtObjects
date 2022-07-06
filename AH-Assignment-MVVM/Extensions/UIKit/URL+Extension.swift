//
//  URL+Extension.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import UIKit

extension URL {

    static var rijksMuseum: URL {
        var components = URLComponents()
        components.scheme = "https"
        // TODO: choose nl or en culture
        components.host = "www.rijksmuseum.nl/api/nl"
        return components.url!
    }
}
