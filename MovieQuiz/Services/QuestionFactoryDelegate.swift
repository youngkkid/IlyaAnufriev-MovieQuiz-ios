//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 14.12.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
