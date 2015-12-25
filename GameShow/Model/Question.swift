//
//  Question.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/24/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit
import SwiftyJSON

public class Question {
    private(set) var title: String
    private(set) var answers: [String]
    private(set) var correctAnswer: AnswerChoice
    private(set) var worth: Int
    
    internal weak var category: Category?
    
    private(set) var state = QuestionState.Unanswered
    
    init(title: String, answers: [String], correctAnswer: Int, worth: Int) throws {
        self.title = title
        self.answers = answers
        self.correctAnswer = AnswerChoice(rawValue: correctAnswer)!
        self.worth = worth
        guard correctAnswer >= 1 && correctAnswer <= 4 else { throw GameShowModelError.QuestionError.AnswerIndexTooLarge }
        guard answers.count == 4 else {
            throw GameShowModelError.QuestionError.AnswerCountIncorrect
        }
    }
    
    convenience init(questionDict: JSON) throws {
        if let title = questionDict["question"].string,
               answerJSONs = questionDict["answers"].array,
               correctAnswer = questionDict["correctAnswer"].int,
               worth = questionDict["worth"].int
        {
            var answerStrings = [String]()
            for answer in answerJSONs {
                answerStrings.append(answer.stringValue)
            }
            try self.init(title: title, answers: answerStrings, correctAnswer: correctAnswer, worth: worth)
        } else {
            print(questionDict)
            throw GameShowModelError.JSONParseError
        }
    }
    
    func selectAnswer(choice: AnswerChoice) {
        if choice == correctAnswer {
            state = .AnsweredCorrect
        } else {
            state = .AnsweredIncorrect
        }
    }
}

public enum QuestionState {
    case Unanswered
    case AnsweredCorrect
    case AnsweredIncorrect
}

enum AnswerChoice : Int {
    case A = 1
    case B = 2
    case C = 3
    case D = 4
}