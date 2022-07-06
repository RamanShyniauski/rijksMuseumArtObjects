//
//  SceneDelegate.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let navigationController = ViewController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
