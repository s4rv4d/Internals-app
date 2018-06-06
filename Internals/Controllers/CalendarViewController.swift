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
    fileprivate let formatterDay :DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)

    var eventArray = [String]()
    var calendarModelArray = [CalendarModel]()
    var sortedCalendarModelArray = [CalendarModel]()
    var counter = true
    var todayDate:Int = 0


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    //MARK:IBOutlets
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var calls: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendarTableView.separatorStyle = .none
        loadData()
        
    }
    

    //MARK:FSCalender methods
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if gregorian.isDateInToday(date){
            print("today",date)
            todayDate = Int(formatterDay.string(from: date))!
        }
        
        let datesss = formatter.string(from: date)
        if eventArray.contains(datesss){
            return 1
        }else{
            return 0
        }
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
                    let newObject = CalendarModel(date: jsonData[i]["date"].stringValue, name: jsonData[i]["name"].stringValue, dateForCell: jsonData[i]["dateForCell"].stringValue)
                    calendarModelArray.append(newObject)
                    eventArray.append(jsonData[i]["date"].stringValue)
                }
                print(calendarModelArray)
                sortedCalendarModelArray = calendarModelArray.sorted{ $0.dateForCell < $1.dateForCell}
                print(sortedCalendarModelArray)
                self.calendarTableView.reloadData()
                self.calls.reloadData()
                print(todayDate)
            }
        }
    }
    
}


//MARK:UITableView properties
extension CalendarViewController :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        cell.cardView.layer.cornerRadius = 14
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cardView.layer.shadowRadius = 3
        cell.cardView.layer.shadowOpacity = 0.16
        cell.workAllotmentButton.layer.cornerRadius = 12
        
        let newStr = Int(sortedCalendarModelArray[indexPath.row].dateForCell.split(separator: "-")[0])
        todayDate = newStr! - todayDate
        cell.noOfDaysLabel.text = String(todayDate)
        if todayDate == 1{
            cell.dayLabel.text = "Day"
        }else{
            cell.dayLabel.text = "Days"
        }
        
        if indexPath.row == 0{
            cell.nextEventLabel.text = "Next Event"
        }else{
             cell.nextEventLabel.text = sortedCalendarModelArray[indexPath.row].dateForCell
        }
       
        cell.eventNameLabel.text = sortedCalendarModelArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        calendarTableView.deselectRow(at: indexPath, animated: true)
    }
}
