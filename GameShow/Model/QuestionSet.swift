//
//  QuestionSet.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/24/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit
import SwiftyJSON

public class QuestionSet: NSObject {
    private(set) var title: String
    private(set) var questionSetDescription: String
    private var jsonData: JSON
    
    lazy var categories: [Category] = { [unowned self] in
        var categories = [Category]()
        if let cats = self.jsonData["categories"].array {
            guard cats.count == 6 else { return categories }
            for cat in cats {
                categories.append(Category(categoryDict: cat)!)
            }
        }
        return categories
    }()
    var totalQuestions: Int {
        return categories.reduce(0) { (curr, cat) -> Int in
            return curr + cat.questions.count
        }
    }
    
    public convenience init?(fileLocation: String) {
        if let data = NSFileManager.defaultManager().contentsAtPath(fileLocation) {
            self.init(fileInformation: JSON(data: data))
        } else {
            return nil
        }
    }
    
    public init(fileInformation: JSON) {
        self.title = fileInformation["title"].stringValue
        self.questionSetDescription = fileInformation["description"].stringValue
        self.jsonData = fileInformation
    }
    
    
    public func questionFor(categoryIndex categoryIndex: Int, questionIndex: Int) -> Question {
        return categories[categoryIndex].questions[questionIndex]
    }
}

public enum GameShowModelError : ErrorType {
    case JSONParseError
    case FileAccessError

    public enum QuestionError : ErrorType {
        case AnswerIndexTooLarge
        case AnswerCountIncorrect
    }
}