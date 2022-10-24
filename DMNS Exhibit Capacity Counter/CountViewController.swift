//
//  CountViewController.swift
//  DMNS Exhibit Capacity Counter
//
//  Created by Lavan Vivek on 7/27/20.
//  Copyright © 2020 Lavan Vivek. All rights reserved.
import UIKit
import FirebaseDatabase

class CountViewController: UIViewController {
    var snpsht: DataSnapshot!
    var day: TheDay!
    var capHits: CapHits!
    var flow: Flow!
    var traffic: Traffic!
    var numPeople: Int = 0;
    var max: Int = 0;
    var total: Int = 0;
    var numCapReach: Int = 0;
    var SelectedExhibit: String = "Exhibit_NA"
    var exhibitSelect: DatabaseReference = Database.database().reference()
    var dataSend: Timer?
    var ginfo: Timer?
    var jsonStr: String = " "
    var nodekey: String = " "
    var flowStr: String = " "
    var capHitStr: String = " "
    var queueStr: String = " "
    var eight: Int = 0
    var nine: Int = 0
    var ten: Int = 0
    var eleven: Int = 0
    var twelve: Int = 0
    var thirteen: Int = 0
    var fourteen: Int = 0
    var fifteen: Int = 0
    var sixteen: Int = 0
    var seventeen: Int = 0
    var eighteen: Int = 0
    var nineteen: Int = 0
    var twenty: Int = 0
    var twentyone: Int = 0
    var exCapcacity: Int = 0
    var qTracker: Qtracker!
    var groupInfor: groupInfo!
    var secondcount: Int = 0
    var enableCount: Bool = false
    var numPeopleTemp: Int = 0
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var gTimer: UIButton!
    @IBOutlet weak var capStatus: UILabel!
    @IBOutlet weak var exhibitChosen: UILabel!
    @IBOutlet weak var increment: UIButton!
    @IBOutlet weak var decrement: UIButton!
    @IBOutlet weak var numPeopleText: UILabel!
    @IBOutlet weak var maxText: UILabel!
    @IBOutlet weak var capReachText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //creates the timer for uploading data
        dataSend = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(runDataSend), userInfo: nil, repeats: true)
        //sets and establishes date format as well as declare and initialize objects that will be used during app startup
        exhibitChosen.text = SelectedExhibit
        numPeopleText.text = "There are \(numPeople) people inside."
        capHits = CapHits()
        flow = Flow(numPatrons: 0)
        groupInfor = groupInfo(numPatrons: 0, eGroupSize: 0, timetaken: 0)
        qTracker = Qtracker(gr: groupInfor)
        traffic = Traffic(fl: flow)
        //change this to make sure any database structural changes carry over
        day = TheDay(capHit: capHits, traf: traffic,mx: 0, nme: SelectedExhibit, numCount: numPeople, numCapReach: 0, tots: 0, qTracker: qTracker)
        let standard = DateFormatter()
        standard.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let tiempo = standard.string(from: today)
        //encodes data into a json format
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(day)
            jsonStr = String(data: jsonData, encoding: .utf8) ?? "failed to create .json dictionary"
        }catch let error{
            print(error)
        }
        //creates database reference to the selected exhibit node
        let exhibits: DatabaseReference = Database.database().reference().child(SelectedExhibit)
        let capacityStorage: DatabaseReference = Database.database().reference().child("The Exhibit Capacities")
        //creates a data query to the latest node in the exhibits database reference object
        let latestQuery: DatabaseQuery = exhibits.queryOrdered(byChild: "date").queryLimited(toLast: 1)
        //Extracts data from the database, loads that data from said database,sets the data onto the app through initializng local variables
        capacityStorage.observe(DataEventType.value, with: {snapshot in
            let postDict = snapshot.value as? NSDictionary ?? [:]
            var capExhibitval: String = self.SelectedExhibit
            if(capExhibitval == "Dogs"){
                capExhibitval = "Dogs Exhibit"
            }
            let exCapacityFire = postDict[capExhibitval] as? Int
            print(postDict)
            if(exCapacityFire != nil){
                self.exCapcacity = exCapacityFire!
            }else{
                self.exCapcacity = 50
            }
            if(self.exCapcacity - self.numPeople <= 10 && self.exCapcacity - self.numPeople > 0){
                self.capStatus.textColor = UIColor.systemOrange
                self.capStatus.text = "Only \(self.exCapcacity - self.numPeople) spots left!"
            }else if(self.exCapcacity - self.numPeople <= 20 && self.exCapcacity - self.numPeople >= 10){
                self.capStatus.textColor = UIColor.systemYellow
                self.capStatus.text = "\(self.exCapcacity - self.numPeople) spots left"
            }else if(self.exCapcacity - self.numPeople == 0){
                self.capStatus.textColor = UIColor.systemRed
                self.capStatus.text = "Capacity Hit!"
            }else if(self.exCapcacity - self.numPeople < 0){
                self.capStatus.textColor = UIColor.systemRed
                self.capStatus.text = "\(self.numPeople - self.exCapcacity) spots overcapacity!"
            }else if(self.exCapcacity - self.numPeople >= 20 && self.exCapcacity - self.numPeople > 0){
                self.capStatus.textColor = UIColor.systemGreen
                self.capStatus.text = "\(self.exCapcacity - self.numPeople) spots left"
            }
        })
        latestQuery.observe(DataEventType.value, with: {snapshot in
            if let resources = snapshot.value as? [String: AnyObject]{
                for(key, obj) in resources{
                    if let dataObject = obj as? [String: AnyObject]{
                        let dateFire = dataObject["date"] as? String
                        if(dateFire == (tiempo)){
                            let numPeopleFire = dataObject["theExhibit"]?["numPeople"] as? Int
                            let totalFire = dataObject["theExhibit"]?["total"] as? Int
                            let maxFire = dataObject["theExhibit"]?["max"] as? Int
                            let capHitTotalFire = dataObject["theExhibit"]?["numCapReach"] as? Int
                            let capFire = dataObject["theExhibit"]?["capHits"]
                            print("Authenticated, Dates Match")
                            self.nodekey = key //sets the nodekey, which is the random string associated with a day
                            do{
                                let array: [String: AnyObject] = capFire as! [String : AnyObject]
                                let jsonData = try! JSONSerialization.data(withJSONObject: array)
                                self.capHitStr = String(data: jsonData, encoding: .utf8) ?? "failed to create .json dictionary"
                                print(self.capHitStr)
                                let dict = self.convertToDictionary(text: self.capHitStr)
                                let eightFire = dict?["eight"] as? Int
                                let nineFire = dict?["nine"] as? Int
                                let tenFire = dict?["ten"] as? Int
                                let elevenFire = dict?["eleven"] as? Int
                                let twelveFire = dict?["twelve"] as? Int
                                let thirteenFire = dict?["thirteen"] as? Int
                                let fourteenFire = dict?["fourteen"] as? Int
                                let fifteenFire = dict?["fifteen"] as? Int
                                let sixteenFire = dict?["sixteen"] as? Int
                                let seventeenFire = dict?["seventeen"] as? Int
                                let eighteenFire = dict?["eighteen"] as? Int
                                let nineteenFire = dict?["nineteen"] as? Int
                                let twentyFire = dict?["twenty"] as? Int
                                let twentyOneFire = dict?["twentyone"] as? Int
                                self.eight = eightFire!
                                self.nine = nineFire!
                                self.ten = tenFire!
                                self.eleven = elevenFire!
                                self.twelve = twelveFire!
                                self.thirteen = thirteenFire!
                                self.fourteen = fourteenFire!
                                self.fifteen = fifteenFire!
                                self.sixteen = sixteenFire!
                                self.seventeen = seventeenFire!
                                self.eighteen = eighteenFire!
                                self.nineteen = nineteenFire!
                                self.twenty = twentyFire!
                                self.twentyone = twentyOneFire!
                            }catch let error{
                                print(error)
                            }
                            self.numPeople = numPeopleFire!
                            self.total = totalFire!
                            self.max = maxFire!
                            self.numCapReach = capHitTotalFire!
                            print(self.numPeople)
                            print(self.nodekey)
                            self.maxText.text = ("With a high of: \(self.max)")
                            self.totalText.text = ("Total number of guests today: \(self.total)")
                            self.numPeopleText.text = "There are \(self.numPeople) people inside."
                            self.capReachText.text = "Number of times cap reached: \(self.numCapReach)"
                            if(self.exCapcacity - self.numPeople <= 10 && self.exCapcacity - self.numPeople > 0){
                                self.capStatus.textColor = UIColor.systemOrange
                                self.capStatus.text = "Only \(self.exCapcacity - self.numPeople) spots left!"
                            }else if(self.exCapcacity - self.numPeople <= 20 && self.exCapcacity - self.numPeople >= 10){
                                self.capStatus.textColor = UIColor.systemYellow
                                self.capStatus.text = "\(self.exCapcacity - self.numPeople) spots left"
                            }else if(self.exCapcacity - self.numPeople == 0){
                                self.capStatus.textColor = UIColor.systemRed
                                self.capStatus.text = "Capacity Hit!"
                            }else if(self.exCapcacity - self.numPeople < 0){
                                self.capStatus.textColor = UIColor.systemRed
                                self.capStatus.text = "\(self.numPeople - self.exCapcacity) spots overcapacity!"
                            }else if(self.exCapcacity - self.numPeople >= 20 && self.exCapcacity - self.numPeople > 0){
                                self.capStatus.textColor = UIColor.systemGreen
                                self.capStatus.text = "\(self.exCapcacity - self.numPeople) spots left"
                            }
                        }else{
                            print("Authetication failed, Dates do not match, uploading date")
                            let dict = self.convertToDictionary(text: self.jsonStr)
                            exhibits.childByAutoId().setValue(dict)
                            let newLatestQuery = exhibits.queryOrdered(byChild: "date").queryLimited(toLast: 1)
                            newLatestQuery.observe(DataEventType.value, with: {snapshot in
                                if let resources = snapshot.value as? [String: AnyObject]{
                                    for(key, obj) in resources{
                                        if let dataObject = obj as? [String: AnyObject]{
                                            _ = dataObject["date"] as? String
                                            let numPeopleFire = dataObject["theExhibit"]?["numPeople"] as? Int
                                            let totalFire = dataObject["theExhibit"]?["total"] as? Int
                                            let maxFire = dataObject["theExhibit"]?["max"] as? Int
                                            let capHitTotalFire = dataObject["theExhibit"]?["numCapReach"] as? Int
                                            let capFire = dataObject["theExhibit"]?["capHits"]
                                            _ = dataObject["theExhibit"]?["capacity"] as? Int
                                            self.nodekey = key
                                            do{
                                                let array: [String: AnyObject] = capFire as! [String : AnyObject]
                                                let jsonData = try! JSONSerialization.data(withJSONObject: array)
                                                self.capHitStr = String(data: jsonData, encoding: .utf8) ?? "failed to create .json dictionary"
                                                print(self.capHitStr)
                                                let dict = self.convertToDictionary(text: self.capHitStr)
                                                let eightFire = dict?["eight"] as? Int
                                                let nineFire = dict?["nine"] as? Int
                                                let tenFire = dict?["ten"] as? Int
                                                let elevenFire = dict?["eleven"] as? Int
                                                let twelveFire = dict?["twelve"] as? Int
                                                let thirteenFire = dict?["thirteen"] as? Int
                                                let fourteenFire = dict?["fourteen"] as? Int
                                                let fifteenFire = dict?["fifteen"] as? Int
                                                let sixteenFire = dict?["sixteen"] as? Int
                                                let seventeenFire = dict?["seventeen"] as? Int
                                                let eighteenFire = dict?["eighteen"] as? Int
                                                let nineteenFire = dict?["nineteen"] as? Int
                                                let twentyFire = dict?["twenty"] as? Int
                                                let twentyOneFire = dict?["twentyone"] as? Int
                                                self.eight = eightFire!
                                                self.nine = nineFire!
                                                self.ten = tenFire!
                                                self.eleven = elevenFire!
                                                self.twelve = twelveFire!
                                                self.thirteen = thirteenFire!
                                                self.fourteen = fourteenFire!
                                                self.fifteen = fifteenFire!
                                                self.sixteen = sixteenFire!
                                                self.seventeen = seventeenFire!
                                                self.eighteen = eighteenFire!
                                                self.nineteen = nineteenFire!
                                                self.twenty = twentyFire!
                                                self.twentyone = twentyOneFire!
                                            }catch let error{
                                                print(error)
                                            }
                                            self.numPeople = numPeopleFire!
                                            self.total = totalFire!
                                            self.max = maxFire!
                                            self.numCapReach = capHitTotalFire!
                                            print(self.numPeople)
                                            print(self.nodekey)
                                            self.maxText.text = ("With a high of: \(self.max)")
                                            self.totalText.text = ("Total number of guests today: \(self.total)")
                                            self.numPeopleText.text = "There are \(self.numPeople) people inside."
                                            self.capReachText.text = "Number of times cap reached: \(self.numCapReach)"
                                            if(self.exCapcacity - self.numPeople <= 10 && self.exCapcacity - self.numPeople > 0){
                                                self.capStatus.textColor = UIColor.systemOrange
                                                self.capStatus.text = "Only \(self.exCapcacity - self.numPeople) spots left!"
                                            }else if(self.exCapcacity - self.numPeople <= 20 && self.exCapcacity - self.numPeople >= 10){
                                                self.capStatus.textColor = UIColor.systemYellow
                                                self.capStatus.text = "\(self.exCapcacity - self.numPeople) spots left"
                                            }else if(self.exCapcacity - self.numPeople == 0){
                                                self.capStatus.textColor = UIColor.systemRed
                                                self.capStatus.text = "Capacity Hit!"
                                            }else if(self.exCapcacity - self.numPeople < 0){
                                                self.capStatus.textColor = UIColor.systemRed
                                                self.capStatus.text = "\(self.numPeople - self.exCapcacity) spots overcapacity!"
                                            }else if(self.exCapcacity - self.numPeople >= 20 && self.exCapcacity - self.numPeople > 0){
                                                self.capStatus.textColor = UIColor.systemGreen
                                                self.capStatus.text = "\(self.exCapcacity - self.numPeople) spots left"
                                            }
                                        }
                                    }
                                }
                                
                                
                            })
                            
                            
                        }
                    }
                }
            }
        })


        // Do any additional setup after dloading the view.
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "ExInfo", sender: self)
    }
    //increases the count (number of people in exhibit)
    @IBAction func increase(_ sender: UIButton) {
        let today = Date()
        let formatterhr = DateFormatter()
        formatterhr.dateFormat = "HH"
        let hr = formatterhr.string(from: today)
        let hour = Int(hr) ?? 0
        numPeople = numPeople + 1;
        total = total + 1
        //updates the database with changed data
        exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("numPeople").setValue(numPeople)
        exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("total").setValue(total)
        //changes the indicator for how many spots are left
        if(exCapcacity - numPeople <= 10 && exCapcacity - numPeople > 0){
            capStatus.textColor = UIColor.systemOrange
            capStatus.text = "Only \(exCapcacity - numPeople) spots left"
        }else if(exCapcacity - numPeople <= 20 && exCapcacity - numPeople >= 10){
            capStatus.textColor = UIColor.systemYellow
            capStatus.text = "\(exCapcacity - numPeople) spots left"
        }else if(exCapcacity - numPeople == 0){
            capStatus.textColor = UIColor.systemRed
            capStatus.text = "Capacity Hit!"
        }else if(exCapcacity - numPeople < 0){
            capStatus.textColor = UIColor.systemRed
            capStatus.text = "\(numPeople - exCapcacity) spots overcapacity!"
        }else if(exCapcacity - numPeople >= 20 && exCapcacity - numPeople > 0){
            capStatus.textColor = UIColor.systemGreen
            capStatus.text = "\(exCapcacity - numPeople) spots left"
        }
        //really long switch statement to check what hour it is and change that value accordingly
        if(numPeople == exCapcacity){
            numCapReach = numCapReach + 1;
            exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("numCapReach").setValue(numCapReach)
            switch hour {
            case 8:
                eight = eight + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("eight").setValue(eight)
            case 9:
                nine = nine + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("nine").setValue(nine)
            case 10:
                ten = ten + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("ten").setValue(ten)
            case 11:
                eleven = eleven + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("eleven").setValue(eleven)
            case 12:
                twelve = twelve + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("twelve").setValue(twelve)
            case 13:
                thirteen = thirteen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("thirteen").setValue(thirteen)
            case 14:
                fourteen = fourteen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("fourteen").setValue(fourteen)
            case 15:
                fifteen = fifteen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("fifteen").setValue(fifteen)
            case 16:
                sixteen = sixteen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("sixteen").setValue(sixteen)
            case 17:
                seventeen = seventeen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("seventeen").setValue(seventeen)
            case 18:
                eighteen = eighteen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("eighteen").setValue(eighteen)
            case 19:
                nineteen = nineteen + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("nineteen").setValue(nineteen)
            case 20:
                twenty = twenty + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("twenty").setValue(twenty)
            case 21:
                twentyone = twentyone + 1;
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("capHits").child("twentyone").setValue(twentyone)
            default:
                print("default case")
            }
        }
        if(numPeople>max){
            max = numPeople
            maxText.text = ("With a high of: \(max)")
            exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("max").setValue(max)
        }
        totalText.text = ("Total number of guests today: \(total)")
        numPeopleText.text = "There are \(numPeople) people inside."
        capReachText.text = "Number of times cap reached: \(numCapReach)"
    }
    //decreases the count numpeople in the exhibit0
    @IBAction func decrease(_ sender: Any) {
        numPeople = numPeople - 1;
        if(numPeople<0){
            numPeople=0;
        }
        //changes the indicator for how many spots are left
        if(exCapcacity - numPeople <= 10 && exCapcacity - numPeople > 0){
            capStatus.textColor = UIColor.systemOrange
            capStatus.text = "Only \(exCapcacity - numPeople) spots left"
        }else if(exCapcacity - numPeople <= 20 && exCapcacity - numPeople >= 10){
            capStatus.textColor = UIColor.systemYellow
            capStatus.text = "\(exCapcacity - numPeople) spots left"
        }else if(exCapcacity - numPeople == 0){
            capStatus.textColor = UIColor.systemRed
            capStatus.text = "Capacity Hit!"
        }else if(exCapcacity - numPeople < 0){
            capStatus.textColor = UIColor.systemRed
            capStatus.text = "\(numPeople - exCapcacity) spots overcapacity!"
        }else if(exCapcacity - numPeople >= 20 && exCapcacity - numPeople > 0){
            capStatus.textColor = UIColor.systemGreen
            capStatus.text = "\(exCapcacity - numPeople) spots left"
        }
        exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("numPeople").setValue(numPeople)
        numPeopleText.text = "There are \(numPeople) people inside."
    }
    @IBAction func gInfoCollectSend(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            gTimer.setTitle("Queue Timer Off", for: .normal)
            let today = Date()
            let formatterhr = DateFormatter()
            formatterhr.dateFormat = "HH"
            var gSize = exCapcacity - numPeople
            if(gSize<0){
                gSize = gSize * -1
            }
            let hr = formatterhr.string(from: today)
            let hour = Int(hr) ?? 0
            if(hour>=0 && hour<21){
                let info: groupInfo = groupInfo(numPatrons: numPeople, eGroupSize: gSize, timetaken: secondcount)
                let jsonEncoder = JSONEncoder()
                numPeopleTemp = 0
                do{
                    let jsonData = try jsonEncoder.encode(info)
                    queueStr = String(data: jsonData, encoding: .utf8) ?? "failed to create .json dictionary"
                }catch let error{
                    print(error)
                }
                let dict = self.convertToDictionary(text: self.queueStr)
                exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("queueTracker").childByAutoId().setValue(dict)
            }
            enableCount = false
            ginfo?.invalidate()
            secondcount = 0
        }else{
            sender.isSelected = true
            gTimer.setTitle("Queue Timer Running", for: .normal)
            enableCount = true
            numPeopleTemp = numPeople
            ginfo = Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(runGinfo), userInfo: nil, repeats: true)
        }
    }
    //converts a json which is in the form of a string into a NSdictionary which can be uploaded to Firebase
    func convertToDictionary(text: String) -> [String: Any]?{
        if let data = text.data(using: .utf8){
            do{
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }catch{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //trigger function for sending data for traffic information
    @objc func runDataSend(){
        print("Data sent")
        let today = Date()
        let formatterhr = DateFormatter()
        formatterhr.dateFormat = "HH"
        let hr = formatterhr.string(from: today)
        let hour = Int(hr) ?? 0
        print(hour)
        if(hour>=9 && hour<21){
            let flow = Flow(numPatrons: numPeople)
            let jsonEncoder = JSONEncoder()
            do{
                let jsonData = try jsonEncoder.encode(flow)
                flowStr = String(data: jsonData, encoding: .utf8) ?? "failed to create .json dictionary"
            }catch let error{
                print(error)
            }
            let dict = self.convertToDictionary(text: self.flowStr)
            exhibitSelect.child(SelectedExhibit).child(nodekey).child("theExhibit").child("traffic").childByAutoId().setValue(dict)
        }
    }
    @objc func runGinfo(){
        if(enableCount){
            secondcount = secondcount + 1
            print("\(secondcount)")
        }
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
