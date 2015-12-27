//
//  GameSetupViewController.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/26/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit

let segueToQSet = "selectAQuestionSet"
let user1NameKey = "com.cixocommunications.GameShow.player1"
let user2NameKey = "com.cixocommunications.GameShow.player2"
class GameSetupViewController: UIViewController {

    @IBOutlet weak var playerOneNameField: UITextField!
    @IBOutlet weak var playerTwoNameField: UITextField!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let user1 = defaults.stringForKey(user1NameKey) {
            self.playerOneNameField.text = user1
        }
        if let user2 = defaults.stringForKey(user2NameKey) {
            self.playerTwoNameField.text = user2
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func startGamePressed(sender: UIButton) {
        if let name1 = playerOneNameField.text, name2 = playerTwoNameField.text {
            if name1 == "" || name2 == "" {
                let alertController = UIAlertController(title: "You must enter a name for both players.", message: nil, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                self.performSegueWithIdentifier(segueToQSet, sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let qSetSelector = segue.destinationViewController as? QuestionSetTableViewController,
               name1 = playerOneNameField.text,
               name2 = playerTwoNameField.text
        {
            qSetSelector.game = Game(playerOneName: name1, playerTwoName: name2)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(name1, forKey: user1NameKey)
            defaults.setObject(name2, forKey: user2NameKey)
        }
    }
}
