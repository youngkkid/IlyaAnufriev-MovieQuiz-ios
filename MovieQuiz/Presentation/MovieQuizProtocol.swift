//
//  MovieQuizProtocol.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 15.01.2025.
//

import Foundation
import UIKit

protocol MovieQuizProtocol: AnyObject {
    func resetBorder()
    func changeState(of button: Bool)
}
