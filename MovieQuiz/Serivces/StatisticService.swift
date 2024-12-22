//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 21.12.2024.
//

import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case total
        case date
        case correctAnswers
        case totalQuestions
        case bestGame
        case gamesCount
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GamesResult {
        get{
            if let correct = storage.value(forKey: Keys.correct.rawValue) as? Int,
               let total = storage.value(forKey: Keys.total.rawValue) as? Int,
               let date = storage.object(forKey: Keys.date.rawValue) as? Date
            {return GamesResult(correct: correct, total: total, date: date)}
            
            return GamesResult(correct: 0, total: 0, date: Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue )
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    private var totalQuestions: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correct = Double(correctAnswers)
            let total = Double(totalQuestions)
            
            return total > 0 ? (correct/total) * 100 : 0.0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        totalQuestions += amount
        
        gamesCount += 1
        
        let currentResult = GamesResult(correct: count, total: amount, date: Date())
        if currentResult.correct > bestGame.correct  {
            bestGame = currentResult
        }
        
    }
}
