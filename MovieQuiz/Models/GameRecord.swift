//
//  GameRecord.swift
//  MovieQuiz
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compare(another: GameRecord) -> Bool {
        return  another.correct < correct
    }
}
