//
//  GamesResult.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 21.12.2024.
//

import Foundation

struct GamesResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GamesResult) -> Bool {
        correct > another.correct
    }
}
