//
//  MovieQuizControllerProtocol.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 15.01.2025.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func resetBorder()
    func changeState(of button: Bool)
}
