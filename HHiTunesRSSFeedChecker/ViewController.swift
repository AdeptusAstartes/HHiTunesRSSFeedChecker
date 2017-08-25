//
//  ViewController.swift
//  HHiTunesRSSFeedChecker
//
//  Created by Donald Angelillo on 8/24/17.
//  Copyright © 2017 Donald Angelillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var feedChecker: HHiTunesRSSFeedChecker = HHiTunesRSSFeedChecker()
    
    @IBOutlet weak var startSimultaneouslyButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var outputSwitch: UISwitch!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
    }

    @IBAction func startButtonHit(sender: UIButton) {
        self.checkFeeds(simultaneously: false)
    }
    
    @IBAction func startSimultaneouslyButtonHit(sender: UIButton) {
        self.checkFeeds(simultaneously: true)
    }
    
    private func checkFeeds(simultaneously: Bool) {
        self.disableButtons()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.feedChecker.findElegibleStoreFrontsForNewItunesFeeds(simultaneously: simultaneously, showDetailedOutput: self.outputSwitch.isOn) { (results) in
            
            self.enableButtons()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            self.feedChecker.printResults(results: results)
        }
    }
    
    private func disableButtons() {
        self.startSimultaneouslyButton.isEnabled = false
        self.startButton.isEnabled = false
    }
    
    private func enableButtons() {
        self.startSimultaneouslyButton.isEnabled = true
        self.startButton.isEnabled = true
    }

}

