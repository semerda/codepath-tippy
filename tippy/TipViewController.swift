//
//  TipViewController.swift
//  tippy
//
//  Created by Ernest on 9/20/16.
//  Copyright © 2016 Purpleblue Pty Ltd. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var mainCalcView: UIView!
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPlusLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var tipPercentage = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billField.delegate = self
        
        navigationController?.navigationBar.backgroundColor = UIColor(netHex:Constants.primartColorInverse)
        
        let attributes = [NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 20)!]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        // Add Settings button to Header Bar
        let buttonSettings: UIButton = UIButton()
        buttonSettings.setImage(UIImage(named: "Settings"), for: .normal)
        buttonSettings.target(forAction: Selector(("navToSettings")), withSender: nil)
        self.view.addSubview(buttonSettings)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = buttonSettings
        self.navigationItem.rightBarButtonItems = [rightItem]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), landscapeImagePhone: UIImage(named: "Settings"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(TipViewController.navToSettings(_:)))
        
        billField.becomeFirstResponder() // Show keyboard on load
        
        self.welcomeUserWithAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSettings() {
        let defaults = UserDefaults.standard
        tipPercentage = (defaults.object(forKey: "tippy_tip_value") as? Double)! / 100
        self.tipPlusLabel.text = String(format: "+ (%@%% tip)", defaults.object(forKey: "tippy_tip_value") as! CVarArg)
        
        // Load bill
        if (defaults.object(forKey: "tippy_bill_dt") != nil && defaults.object(forKey: "tippy_bill_value") != nil) {
            let date2 = defaults.object(forKey: "tippy_bill_dt") as! Date
            let minutes = date2.minutes(from: NSDate() as Date)
            //print(minutes)
            
            // If under 10 mins lets display the last bill
            if (minutes > -10) {
                billField.text = String(format: "%@", (defaults.object(forKey: "tippy_bill_value") as! CVarArg))
            } else {
                // Restart bill memory
                defaults.removeObject(forKey: "tippy_bill_dt")
                defaults.removeObject(forKey: "tippy_bill_value")
            }
        }
        
        self.calculateTip()
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true);
    }
    
    @IBAction func navToSettings(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowSettingsSegue", sender: nil)
    }
    
    @IBAction func onChangeCalculateTip(_ sender: AnyObject) {
        self.calculateTip()
    }
    
    func calculateTip() {
        let bill = Double(billField.text!) ?? 0
        
        let tip = bill * tipPercentage
        let total = bill + tip
        
        // Use device's locale currency
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        
        tipLabel.text = String.localizedStringWithFormat("%@%.2f", currencySymbol, tip)
        totalLabel.text = String.localizedStringWithFormat("%@%.2f", currencySymbol, total)
        
        if (bill > 0) {
            // Remember the bill so when we restart the app load the last value
            let defaults = UserDefaults.standard
            defaults.set(NSDate(), forKey: "tippy_bill_dt")
            defaults.set(bill, forKey: "tippy_bill_value")
            defaults.synchronize()
        }
    }
    
    func welcomeUserWithAnimations() {
        // Optionally initialize the property to a desired starting value
        self.mainCalcView.alpha = 0
        self.welcomeView.alpha = 1
        UIView.animate(withDuration: 0.8, animations: {
            // This causes first view to fade in and second view to fade out
            self.mainCalcView.alpha = 1
            self.welcomeView.alpha = 0 }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        
        loadSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
}

