//
//  ViewController.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/23/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit
let segueToQuestionIdentifier = "showQuestionHotseat"
class ViewController: UIViewController {

    var currentGame: Game!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    @IBOutlet var categoryLabels: [UILabel]!

    @IBOutlet var buttons: [UIButton]!
    var completedQuestions = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if let path = NSBundle.mainBundle().pathForResource("Trivia.json", ofType: nil), qSet = QuestionSet(fileLocation: path) {
//            self.currentGame = Game(questionSet: qSet, playerOneName: "Jonathan", playerTwoName: "Jeshua")
//        }
        titleLabel.text = self.currentGame.questionSet!.title
        for label in categoryLabels {
            let index = (label.tag / 10) - 1
            label.text = currentGame.questionSet!.categories[index].title
        }
        for button in buttons {
            let indices = categoryAndQuestionIndices(button.tag)
            button.setTitle("\(currentGame.questionSet!.categories[indices.category].questions[indices.question].worth)", forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        currentPlayerLabel.text = "Current Player: \(currentGame.currentPlayer.name)"
        self.playerOneScoreLabel.text = "\(currentGame.playerOne.name): \(currentGame.playerOne.score)"
        self.playerTwoScoreLabel.text = "\(currentGame.playerTwo.name): \(currentGame.playerTwo.score)"
        if self.completedQuestions == currentGame.questionSet!.totalQuestions {
            let controller = UIAlertController(title: "Winner", message: currentGame.winnerString, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(controller, animated: true, completion: nil)
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func questionButtonPressed(sender: UIButton) {
        sender.enabled = false
        sender.userInteractionEnabled = false
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
        self.completedQuestions += 1
        self.performSegueWithIdentifier(segueToQuestionIdentifier, sender: sender)
        sender.alpha = 0.1

    
    }
    
    func categoryAndQuestionIndices(senderTag: Int) -> (category: Int, question: Int) {
        let catIndex = (senderTag / 1000) - 1
        let qIndex = (senderTag % 1000) / 100 - 1
        return (catIndex, qIndex)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueToQuestionIdentifier {
            if let sender = sender {
                let indices = categoryAndQuestionIndices(sender.tag)
                let question = currentGame.questionSet!.questionFor(categoryIndex: indices.category, questionIndex: indices.question)
                let destination = segue.destinationViewController as! QuestionViewController
                destination.question = question
                destination.delegate = currentGame
            }
            
        }
    }

}

