//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 21.12.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int {get}
    var bestGame: GamesResult {get}
    var totalAccuracy: Double {get}
    
    func store(correct count: Int, total amount: Int)
}
