//
//  QuestionViewController.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/24/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var question: Question!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet weak var answerStatusLabel: UILabel!

    var delegate: QuestionViewControllerDelegate?
    
    let tapRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Disable Menu button to go back.
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)

        self.answerStatusLabel.text = ""
        if question == nil {
            question = try! Question(title: "This is a test question.  Choose A.", answers: ["Choose me!", "Don't choose me", "Sorry, not this one", "Try another"], correctAnswer: 1, worth: 100)
        }
        questionLabel.text = question.title
        titleLabel.text = "\(question.category?.title ?? "Category") - \(question.worth)"
        configureQuestionButtons()
    }
    
    func configureQuestionButtons() {
        for answerBtn in answerButtons {
            let choice = AnswerChoice(rawValue: answerBtn.tag)!
            answerBtn.setTitle("\(choice). \(question.answers[answerBtn.tag - 1])", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tapRecognizer.enabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tapRecognizer.enabled = false
    }
    
    @IBAction func selectedButton(sender: UIButton) {
        let answer = AnswerChoice(rawValue: sender.tag)!
        let correctAnswer = question.correctAnswer
        question.selectAnswer(answer)
        var correctAnswerButton: UIButton!
        answerButtons.forEach { (btn) -> () in
            btn.userInteractionEnabled = false
            if btn.tag == correctAnswer.rawValue {
                correctAnswerButton = btn
                return
            }
            if btn === sender { return }
            btn.alpha = 0.1
            btn.enabled = false
        }
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
        sender.backgroundColor = UIColor.redColor()
        correctAnswerButton.backgroundColor = UIColor.greenColor()
        if answer == correctAnswer {
            self.answerStatusLabel.text = "Correct!"
            delegate?.didSelectCorrectAnswer(self.question)
        } else {
            self.answerStatusLabel.text = "No, the correct answer is \(correctAnswer)."
            delegate?.didSelectIncorrectAnswer(self.question)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [unowned self] in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UIPress
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        if (presses.first?.type == .Menu) {
            // Overruled!
        } else {
            super.pressesBegan(presses, withEvent: event)
        }
    }

}

protocol QuestionViewControllerDelegate {
    func didSelectCorrectAnswer(question: Question)
    func didSelectIncorrectAnswer(question: Question)
}
