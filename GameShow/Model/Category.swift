//
//  Category.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/24/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit
import SwiftyJSON

public class Category {
    private(set) var title: String
    private(set) var questions: [Question]
    
    init(title: String, questions: [Question]) {
        self.title = title
        self.questions = questions
        for q in self.questions {
            q.category = self
        }
    }
    
    public convenience init?(categoryDict: JSON) {
        if let title = categoryDict["title"].string, rawQuestions = categoryDict["questions"].array {
            guard rawQuestions.count == 5 else { return nil }
            var questions = [Question]()
            for question in rawQuestions {
                do {
                    let q = try Question(questionDict: question)
                    questions.append(q)
                } catch {
                    print(error)
                }
            }
            self.init(title: title, questions: questions)
        } else {
            return nil
        }
    }
}
