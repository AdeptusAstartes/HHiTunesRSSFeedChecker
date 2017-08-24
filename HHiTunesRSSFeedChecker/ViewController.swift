//
//  ViewController.swift
//  HHiTunesRSSFeedChecker
//
//  Created by Donald Angelillo on 8/24/17.
//  Copyright © 2017 Donald Angelillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let feedChecker: HHiTunesRSSFeedChecker = HHiTunesRSSFeedChecker()
    
    @IBOutlet weak var startSimultaneouslyButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func startButtonHit(sender: UIButton) {
        self.checkFeeds(simultaneously: false)
    }
    
    @IBAction func startSimultaneouslyButtonHit(sender: UIButton) {
        self.checkFeeds(simultaneously: true)
    }
    
    private func checkFeeds(simultaneously: Bool) {
        self.feedChecker.findElegibleStoreFrontsForNewItunesFeeds(simultaneously: simultaneously) { (results) in
            print("HUH?")
        }
    }

}

