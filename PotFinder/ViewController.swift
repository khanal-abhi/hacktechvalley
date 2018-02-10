//
//  ViewController.swift
//  PotFinder
//
//  Created by Abhinash Khanal on 2/10/18.
//  Copyright © 2018 Abhinash.io. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {


    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    var handle: AuthStateDidChangeListenerHandle? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func userDidTapGetStarted(_ sender: UIButton) {
        if let mapViewController = Bundle.main.loadNibNamed("MapViewController",
                                                            owner: nil,
                                                            options: nil)?.first as? MapViewController {
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    @IBAction func userDidLogin(_ sender: Any) {
    }

    @IBAction func userDidLogout(_ sender: Any) {
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolbarItems?.removeAll()
        self.title = "PotFinder"
        handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            guard let it = self else {
                return
            }
            if let user = user {
                // Logged in
                it.toolbarItems?.append(it.logoutButton)
            } else {
                // Logged out
                it.toolbarItems?.append(it.loginButton)
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let handle = self.handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }


}

