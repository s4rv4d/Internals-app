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

    var eventArray = [String]()
    var calendarModelArray = [CalendarModel]()
    var counter = true


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    //MARK:IBOutlets
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var calls: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
    }
    

    //MARK:FSCalender methods
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let datesss = formatter.string(from: date)
        print(datesss)
        if eventArray.contains(datesss){
            return 1
        }else{
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected:","\(formatter.string(from: date))")
    }
    
    
    
    
    //need to work out a way to load data first before loading calendar
    //need to go into the documentation
    
    
    
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
                    eventArray.append(jsonData[i]["date"].stringValue)
                }
                self.calendarTableView.reloadData()
                print(eventArray)
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
