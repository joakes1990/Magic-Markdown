//
//  DayNightPopoverController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 3/11/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import UIKit

class DayNightPopoverController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: Constants.useDarkmode) {
            self.popoverPresentationController?.backgroundColor = Constants.nightTimeBarColor
        } else {
            self.popoverPresentationController?.backgroundColor = Constants.dayTimeBarColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleDarkMode(on: Bool) {
        self.popoverPresentationController?.backgroundColor = on ? Constants.nightTimeBarColor : Constants.dayTimeBarColor
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
