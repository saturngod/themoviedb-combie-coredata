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
    case DetailScreen = "DetailViewController"
}

protocol RouterType {
    func route(from: UIViewController?,to: RoutePath,present: Bool,animated: Bool,passModel: DefaultViewModelType?)
}
class Router: RouterType {
    
    func route(from: UIViewController?, to: RoutePath,present: Bool, animated: Bool, passModel: DefaultViewModelType?) {

        guard let from = from else {
            return
        }
        
        switch to {
        case .DetailScreen:
            let vc = DetailViewController(nibName: to.rawValue, bundle: .main)
            if(present) {
                from.present(vc, animated: true)
            }
            else {
                from.navigationController?.pushViewController(vc, animated: animated)
            }
            if let pass = passModel {
                vc.vm = pass
            }
        default:
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
    
    
}
