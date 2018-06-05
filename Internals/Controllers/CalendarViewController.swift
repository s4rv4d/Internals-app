//
//  CalendarViewController.swift
//  Internals
//
//  Created by Sarvad shetty on 6/5/18.
//  Copyright © 2018 Sarvad shetty. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseDatabase
import SwiftyJSON


    //MARK:Variables
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)

    let eventArray = ["2018-06-03","2018-06-29"]
    var calendarModelArray = [CalendarModel]()




class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    //MARK:IBOutlets
    @IBOutlet weak var calendarTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadData()
    }


    //MARK:FSCalender methods
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let datesss = formatter.string(from: date)
//        if eventArray.contains(datesss){
//            return 1
//        }else{
//            return 0
//        }
        return 0
//
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected:","\(formatter.string(from: date))")
    }
    
    //MARK:Functions
    func loadData(){
        Database.database().reference().child("events").observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject> {
                let jsonData = JSON(data)
                print(jsonData)
                let dataKeys = data.keys
                for i in dataKeys{
                   let newObject = CalendarModel(date: jsonData[i]["date"].stringValue, name: jsonData[i]["name"].stringValue)
                    calendarModelArray.append(newObject)
                }
                self.calendarTableView.reloadData()
            }
        }
    }
    
}

extension CalendarViewController :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        
        return cell
    }
}
