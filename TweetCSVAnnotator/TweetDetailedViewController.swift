//
//  ViewController.swift
//  TweetCSVAnnotator
//
//  Created by Logan Lane on 2/28/21.
//

import UIKit

class TweetDetailedViewController: UIViewController{
    
    
    var TweetSegueContent = ""
    var TweetSegueType = false
    var arraynum = 0
    
    func updateTweetView(){
        TweetView.text = TweetList[arraynum].tweet
        print(arraynum)
    }

    //Debugging function used to output the "Type" variable of each TweetList Entry
    func test(){
        for n in 0...99 {
            print(TweetList[n].Type)
        }
    }
    @IBOutlet weak var TweetView: UITextView!
    
    //User presses normal button and it updates the TweetList Array and moves on to next entry
    @IBAction func ItsNormal(_ sender: Any) {
        TweetSegueType = false
        
        if(arraynum == TweetList.count - 1){
            TweetList[arraynum].Type = false
            self.navigationController?.popViewController(animated: true)
        }
        else{
            TweetView.text = TweetList[arraynum].tweet
            TweetList[arraynum].Type = false
            arraynum = arraynum + 1
            updateTweetView()
            test()
        }
    }
    
    //User presses hate speech button and it updates the TweetList Array and moves on to next entry
    @IBAction func ItsHateful(_ sender: Any) {
        TweetSegueType = true
        
        if arraynum == TweetList.count - 1 {
            TweetList[arraynum].Type = true
            self.navigationController?.popViewController(animated: true)
        }
        
        else{
            TweetView.text = TweetList[arraynum].tweet
            TweetList[arraynum].Type = true
            arraynum = arraynum + 1
            updateTweetView()
            test()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTweetView()
        // Do any additional setup after loading the view.
    }
}

