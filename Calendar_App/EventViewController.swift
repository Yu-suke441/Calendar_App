//
//  EventViewController.swift
//  Calendar_App
//
//  Created by Yusuke Murayama on 2021/02/09.
//

import UIKit
import RealmSwift

// ディスプレイサイズの取得
let w2 = UIScreen.main.bounds.size.width
let h2 = UIScreen.main.bounds.size.height

// スケジュール内容入力テキスト
let eventText = UITextView(frame: CGRect(x: (w2 - 300) / 2, y: 100, width: 300, height: 200))

// 日付フォーム(UIDatePickerを使用)
let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 300, width: w2, height: 300))

// 日付表示
let date_text = UILabel(frame: CGRect(x: (w2 - 300) / 2, y: 570, width: 300, height: 20))

class EventViewController: UIViewController {

    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // スケジュール内容入力テキスト
        eventText.text = ""
        eventText.layer.borderColor = UIColor.gray.cgColor
        eventText.layer.borderWidth = 1.0
        eventText.layer.cornerRadius = 10.0
        view.addSubview(eventText)
        
        //　日付フォーム設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.addTarget(self, action: #selector(picker(_:)), for: .valueChanged)
        view.addSubview(datePicker)
        
        
        // 入力ボタン
        let eventInsert = UIButton(frame: CGRect(x: (w2 - 200) / 2, y: 480, width: 200, height: 40))
        eventInsert.setTitle("入力", for: UIControl.State())
        eventInsert.setTitleColor(.blue, for: UIControl.State())
        eventInsert.backgroundColor = .white
        eventInsert.layer.cornerRadius = 10.0
        eventInsert.layer.borderColor = UIColor.orange.cgColor
        eventInsert.layer.borderWidth = 1.0
        eventInsert.layer.shadowOpacity = 0.5
        eventInsert.layer.shadowOffset = CGSize(width: 2, height: 2)
        eventInsert.addTarget(self, action: #selector(saveEvent(_:)), for: .touchUpInside)
        view.addSubview(eventInsert)
        
        // 戻るボタン
        let backButton = UIButton(frame: CGRect(x: 30 , y: 30, width: 50, height: 30))
        backButton.setTitle("戻る", for: UIControl.State())
        backButton.setTitleColor(.blue, for: UIControl.State())
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 10.0
        backButton.layer.borderWidth = 1.0
        backButton.layer.borderColor = UIColor.orange.cgColor
        backButton.layer.shadowOpacity = 0.5
        backButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        backButton.addTarget(self, action: #selector(onBackClick(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        date_text.text = formatter.string(from: datePicker.date)
        
        //タップでキーボードを下げる
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        //下にスワイプでキーボードを下げる
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
        }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // 画面遷移(toppage)
    @objc func onBackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //　日付フォーム
    @objc func picker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        date_text.text = formatter.string(from: sender.date)
//        view.addSubview(date_text)
    }
    
    // DBへの書き込み処理
    @objc func saveEvent(_ : UIButton) {
        let realm = try! Realm()
        
        try! realm.write {
            let Events = [Event(value: ["date": date_text.text, "event": eventText.text])]
            realm.add(Events)
            print("データ書き込み中///")
        }
        print("データの書き込み完了！")
        
        dismiss(animated: true, completion: nil)
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
