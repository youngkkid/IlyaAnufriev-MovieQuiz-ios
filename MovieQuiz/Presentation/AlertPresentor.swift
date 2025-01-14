//
//  AlertPresentor.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 16.12.2024.
//

import UIKit

final class ResultAlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion?()
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
