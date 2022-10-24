//
//  ViewController.swift
//  DMNS Exhibit Capacity Counter
//  Created by Lavan Vivek on 7/27/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
//
import UIKit
import FirebaseDatabase
//This viewcontroller sets all the buttons in place, connect the buttons to segue to the next screen and sends which exhibit was selected
class ViewController: UIViewController {

    var ExhibitOne: String = "Exhibit1";
    var ExhibitTwo: String = "Exhibit2";
    var ExhibitThree: String = "Exhibit3";
    var ExhibitFour: String = "Exhibit4;"
    var TEOne: String = "Exhibit5"
    var TETwo: String = "Exhibit6"
    @IBOutlet weak var TE: UIButton!
    @IBOutlet weak var PJ: UIButton!
    @IBOutlet weak var EH: UIButton!
    @IBOutlet weak var GM: UIButton!
    @IBOutlet weak var TE2: UIButton!
    @IBOutlet weak var SO: UIButton!
    
    @IBOutlet weak var FirstLabel: UILabel!
    @IBOutlet weak var SecondLabel: UILabel!
    @IBOutlet weak var ThirdLabel: UILabel!
    @IBOutlet weak var FourthLabel: UILabel!
    @IBOutlet weak var FifthLabel: UILabel!
    @IBOutlet weak var SixthLabel: UILabel!
    
    
    var SelectedExhibition: String = " "		    	
    var ref: DatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        let exhibitSelect: DatabaseReference = Database.database().reference().child("The Available Exhibits")
        exhibitSelect.observe(DataEventType.value, with: {snapshot in
            let postDict = snapshot.value as? NSDictionary ?? [:]
            //Gems and Minerals
            let ExhibitOneFire = postDict["Exhibit 1"] as? String
            //EH
            let ExhibitTwoFire = postDict["Exhibit 2"] as? String
            //PJ
            let ExhibitThreeFire = postDict["Exhibit 3"] as? String
            //SO
            let ExhibitFourFire = postDict["Exhibit 4"] as? String
            //AOTB
            let TEOneFire = postDict["Notice One"] as? String
            //Dogs
            let TETwoFire = postDict["Notice Two"] as? String
            print(postDict)
            self.ExhibitOne = ExhibitOneFire!
            self.ExhibitTwo = ExhibitTwoFire!
            self.ExhibitThree = ExhibitThreeFire!
            self.ExhibitFour = ExhibitFourFire!
            self.TEOne = TEOneFire!
            self.TETwo = TETwoFire!
            self.FirstLabel.text = self.TEOne
            self.SecondLabel.text = self.ExhibitThree
            self.ThirdLabel.text = self.ExhibitTwo
            self.FourthLabel.text = self.ExhibitOne
            self.FifthLabel.text = self.TETwo
            self.SixthLabel.text = self.ExhibitFour
        })
        
        // Do any additional setup after loading the view.
    }
    //button 1
    @IBAction func TESelected(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            PJ.isSelected = false
            EH.isSelected = false
            GM.isSelected = false
            TE2.isSelected = false
            SO.isSelected = false
        }else{
            sender.isSelected = true
            PJ.isSelected = false
            EH.isSelected = false
            GM.isSelected = false
            TE2.isSelected = false
            SO.isSelected = false
            SelectedExhibition = TEOne
            performSegue(withIdentifier: "ExName", sender: self)
        }
    }
    //Button 2
    @IBAction func PJSelected(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            TE.isSelected = false
            EH.isSelected = false
            GM.isSelected = false
            TE2.isSelected = false
            SO.isSelected = false
        }else{
            sender.isSelected = true
            EH.isSelected = false
            GM.isSelected = false
            SO.isSelected = false
            SelectedExhibition = ExhibitThree
            performSegue(withIdentifier: "ExName", sender: self)
        }
    }
    //Button 3
    @IBAction func ESelected(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            PJ.isSelected = false
            TE.isSelected = false
            GM.isSelected = false
            TE2.isSelected = false
            SO.isSelected = false
        }else{
            sender.isSelected = true
            PJ.isSelected = false
            GM.isSelected = false
            SO.isSelected = false
            SelectedExhibition = ExhibitTwo
            performSegue(withIdentifier: "ExName", sender: self)
        }
    }
    
    //Button 4
    @IBAction func GMSelected(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            PJ.isSelected = false
            EH.isSelected = false
            TE.isSelected = false
            TE2.isSelected = false
            SO.isSelected = false
        }else{
            sender.isSelected = true
            PJ.isSelected = false
            EH.isSelected = false
            SO.isSelected = false
            SelectedExhibition = ExhibitOne
            performSegue(withIdentifier: "ExName", sender: self)
        }
    }
    
    //Button 5
    @IBAction func TE2Selected(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            PJ.isSelected = false
            EH.isSelected = false
            TE.isSelected = false
            GM.isSelected = false
            SO.isSelected = false
        }else{
            sender.isSelected = true
            PJ.isSelected = false
            EH.isSelected = false
            TE.isSelected = false
            GM.isSelected = false
            SO.isSelected = false
            SelectedExhibition = TETwo
            performSegue(withIdentifier: "ExName", sender: self)
        }
    }
    
    //Button 6
    @IBAction func SOSelect(_ sender: UIButton)   {
        if sender.isSelected{
            sender.isSelected = false
            PJ.isSelected = false
            EH.isSelected = false
            GM.isSelected = false
            TE2.isSelected = false
            TE.isSelected = false
        }else{
            sender.isSelected = true
            PJ.isSelected = false
            EH.isSelected = false
            GM.isSelected = false
            SelectedExhibition = ExhibitFour
            performSegue(withIdentifier: "ExName", sender: self)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nameExtradition = segue.destination as! CountViewController
        nameExtradition.SelectedExhibit = self.SelectedExhibition
    }
}
