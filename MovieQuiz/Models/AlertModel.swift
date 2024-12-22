//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 15.12.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)?
}
