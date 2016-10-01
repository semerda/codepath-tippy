//
//  SettingsTableViewController.swift
//  tippy
//
//  Created by Ernest on 9/20/16.
//  Copyright © 2016 Purpleblue Pty Ltd. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    /*
    enum TipAmounts: Double {
        case d0 = 0.15
        case d1 = 0.18
        case d2 = 0.2
        case d3 = 0.25
    }
    */

    @IBOutlet weak var tipPickerView: UIPickerView!
    @IBOutlet weak var tipCustomTextField: UITextField!
    @IBOutlet weak var localeCurrencyLabel: UILabel!
    
    let pickerData = ["10%", "15%", "18%", "20%", "25%", "Custom"]
    let pickerDataPerc = [10, 15, 18, 20, 25]
    var tipAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tipPickerView.dataSource = self
        tipPickerView.delegate = self
        tipCustomTextField.delegate = self
        
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.title = "Settings"
        let attributes = [NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 20)!]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSettings))
        navigationItem.rightBarButtonItem = saveButton
        
        loadSettings()
        
        // Remove extra empty cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true);
    }
    
    private func textFieldDidBeginEditing(textField: UITextField) -> Bool {
        tipPickerView.selectRow(pickerData.count-1, inComponent: 0, animated: true)
        return true
    }
    
    // MARK - Delegates and data sources
    // MARK - Data Sources
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // MARK - Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var tipText = pickerData[row].replacingOccurrences(of: "%", with: "")
        if (tipText == "Custom") { // Custom allows person to type their own in
            tipText = ""
        } else {
            tipAmount = Int(tipText)!
            tipCustomTextField.text = ""
        }
        //tipSelectedField.text = tipText
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
    }
    
    /* persistent key-value store called NSUserDefaults */
    
    @IBAction func saveSettings(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(((tipCustomTextField.text?.isEmpty)! ? tipAmount : Double(tipCustomTextField.text!)), forKey: "tippy_tip_value")
        defaults.synchronize()
        
        _ = self.navigationController?.popViewController(animated: true) // note _ = since this method returns bool and we dont want to do anyting with it otherwise it say unused
    }

    func loadSettings() {
        let defaults = UserDefaults.standard
        tipAmount = defaults.object(forKey: "tippy_tip_value") as! Int
        if (pickerDataPerc.contains(tipAmount)) {
            tipPickerView.selectRow(pickerDataPerc.index(of: tipAmount)!, inComponent: 0, animated: true)
        } else {
            tipPickerView.selectRow(pickerData.count-1, inComponent: 0, animated: true)
            tipCustomTextField.text = String(format: "%@", (defaults.object(forKey: "tippy_tip_value") as! CVarArg))
        }
        
        //print(defaults.object(forKey: "tippy_tip_value"))
        
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        let currencyCode = locale.currencyCode!
        
        localeCurrencyLabel.text = String(format: "%@ %@", currencySymbol, currencyCode)
    }
}
