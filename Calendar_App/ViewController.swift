//
//  ViewController.swift
//  Calendar_App
//
//  Created by Yusuke Murayama on 2021/02/09.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

//ディスプレイサイズの取得
let w = UIScreen.main.bounds.size.width
let h = UIScreen.main.bounds.size.height



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    

    //スケジュール内容
    let labelDate = UILabel(frame: CGRect(x: 5, y: 500, width: 400, height: 50))
    //主なスケジュールの表示
    let labelTitle = UILabel(frame: CGRect(x: 0, y: 450, width: 180, height: 50))
    //　カレンダー部分
    let dateView = FSCalendar(frame: CGRect(x: 0, y: 30, width: w, height: 350))
    // 日付の表示
    let Date = UILabel(frame: CGRect(x: 5, y: 370, width: 200, height: 80))
    
    var datesWithEvents: Set<String> = []
    
    // タップした日付を入れる変数
    var selectedDate = ""
    
    
    var list: Results<Event>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // カレンダーの設定
        self.dateView.dataSource = self
        self.dateView.delegate = self
        self.dateView.today = nil
        self.dateView.tintColor = .red
        self.view.backgroundColor = .systemYellow
        dateView.backgroundColor = .clear
        dateView.calendarHeaderView.tintColor = .clear
        view.addSubview(dateView)
        
        // 日付表示設定
        Date.text = ""
        Date.font = UIFont.systemFont(ofSize: 60.0)
        Date.textColor = .black
        view.addSubview(Date)
        
        // 主なスケジュール表示設定
        labelTitle.text = ""
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.systemFont(ofSize: 20.0)
        view.addSubview(labelTitle)
        
        // スケジュール内容表示設定
        labelDate.text = ""
        labelDate.font = UIFont.systemFont(ofSize: 18.0)
        view.addSubview(labelDate)
        
        // スケジュール追加ボタン
        let addBtn = UIButton(frame: CGRect(x: w - 90, y: h - 150, width: 60, height: 60))
        addBtn.setTitle("+", for: UIControl.State())
        addBtn.setTitleColor(.white, for: UIControl.State())
        addBtn.backgroundColor = .blue
        addBtn.layer.cornerRadius = 30.0
        addBtn.layer.shadowOpacity = 0.5
        addBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        addBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.addSubview(addBtn)
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dateView.reloadData()
        
    }

//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        formatter.calendar = Calendar(identifier: .gregorian)
//        formatter.timeZone = TimeZone.current
//        formatter.locale = Locale.current
//        let calendarDay = formatter.string(from: date)
//
//        // Realmオブジェクトの生成
//        let realm = try! Realm()
//        // 参照（全データ）を取得
//        let events = realm.objects(Event.self)
//
//        if events.count > 0 {
//            for i in 0 ..< events.count {
//                if i == 0 {
//                    datesWithEvents = [events[i].date]
//                } else {
//                    datesWithEvents.insert(events[i].date)
//                }
//            }
//        } else {
//            datesWithEvents = []
//        }
//
//        return datesWithEvents.contains(calendarDay) ? 1 : 0
//
//
//    }
    
    
    
    
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド
    func judgeHoliday(_ date: Date) -> Bool {
        // 祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // date型　-> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int) {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return(year,month,day)
    }
    
    // 曜日判定
    func getWeekIndex(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色をかえる
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        // 祝日判定をする
        if self.judgeHoliday(date) {
            return UIColor.red
        }
        
        // 土日の判定
        let weekday = self.getWeekIndex(date)
        if weekday == 1 {
            return UIColor.red
        } else if weekday == 7 {
            return UIColor.blue
        }
        
        return nil
         
    }
    
    @objc func onClick(_: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondController = storyboard.instantiateViewController(identifier: "Insert")
        present(secondController, animated: true, completion: nil)
    }
    
    // カレンダー処理
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        labelTitle.text = "スケジュール"
        labelTitle.textColor = .white
        labelTitle.backgroundColor = .blue
        labelTitle.layer.cornerRadius = 10.0
        view.addSubview(labelTitle)
        
        //予定あり場合DBから取得表示
        //なしの場合「予定なし」を表示
        labelDate.text = "予定なし"
        labelDate.textColor = .gray
        view.addSubview(labelDate)
        
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        
        let da = "\(year)/\(m)/\(d)"
        
        // クリックで日付を表示
        Date.text = "\(m)/\(d)"
        view.addSubview(Date)
        
        //　スケジュールの取得
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(da)'")
        
        for ev in result {
            if ev.date == da {
                labelDate.text = ev.event
                labelDate.textColor = .black
                view.addSubview(labelDate)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "calendarsCell", for: indexPath)
        cell.textLabel!.text = list[indexPath.row].event
        return cell
    }
    
    
}


