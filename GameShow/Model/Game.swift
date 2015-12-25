//
//  Game.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/24/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit

class Game: NSObject, QuestionViewControllerDelegate {
    var questionSet: QuestionSet
    var playerOne: PlayerProfile
    var playerTwo: PlayerProfile
    var currentPlayer: PlayerProfile
    
    init(questionSet: QuestionSet, playerOneName: String, playerTwoName: String) {
        self.questionSet = questionSet
        self.playerOne = PlayerProfile(name: playerOneName)
        self.playerTwo = PlayerProfile(name: playerTwoName)
        self.currentPlayer = self.playerOne
    }
    
    func didSelectCorrectAnswer(question: Question) {
        self.currentPlayer.score += question.worth
        self.toggleCurrentPlayer()
    }

    func didSelectIncorrectAnswer(question: Question) {
        self.currentPlayer.score -= question.worth
        self.toggleCurrentPlayer()
    }

    func toggleCurrentPlayer() {
        if self.currentPlayer === self.playerOne {
            self.currentPlayer = self.playerTwo
        } else {
            self.currentPlayer = self.playerOne
        }
    }
}