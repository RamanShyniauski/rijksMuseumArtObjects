//
//  Bundle+Extension.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import Foundation

extension Bundle {

    var apiKey: String? {
        infoDictionary?["API_KEY"] as? String
    }
}
