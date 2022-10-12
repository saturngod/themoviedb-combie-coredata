//
//  Router.swift
//  TheMoviesDB
//
//  Created by Htain Lin Shwe on 12/10/2022.
//

import UIKit


enum RoutePath: String {
    case MainScreen = "TabBarController"
    case SplashScreen = "SplashScreenViewController"
}

protocol RouterType {
    func route(from: UIViewController?,to: RoutePath,present: Bool,animated: Bool)
}
class Router: RouterType {
    
    func route(from: UIViewController?, to: RoutePath,present: Bool, animated: Bool) {

        guard let from = from else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: to.rawValue)
        vc.modalPresentationStyle = .fullScreen
        if(present) {
            from.present(vc, animated: animated)
        }
        else {
            from.navigationController?.pushViewController(vc, animated: animated)
        }
        
    }
    
    
}
