//
//  IntroViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/12/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Functions.updateLocation()
    }
}
