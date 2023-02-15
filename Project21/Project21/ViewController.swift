//
//  ViewController.swift
//  Project21
//
//  Created by Айсен Еремеев on 11.02.2023.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    // Метод для запроса разрешения на выполнение алертов, со значками или звуком.
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    // Метод для формирования расписания и данных для уведомлений которые состоят из трех вещей: 1) Контента (что показывать); 2) Триггера (Когда показывать); 3) Запроса (комбинации контента и триггера)
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        
        // 1) Что показывать:
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        // 2) Когда показывать
        var dateComponents = DateComponents()
            
        dateComponents.hour = 17
        dateComponents.minute = 20
        
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    @objc func remindLater() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        
        // 1) Что показывать:
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        // 2) Когда показывать
        var dateComponents = DateComponents()
            
        dateComponents.hour = 17
        dateComponents.minute = 20
        
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    func setAppDelegateAsPushNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: .foreground)
        let close = UNNotificationAction(identifier: "close", title: "Close", options: .destructive)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder, close], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Выполнился escaping closure")
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
            case "show":
                let ac = UIAlertController(title: "Закрытие приложения", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Вы уверены что хотите закрыть уведомление?", style: .cancel))
                present(ac, animated: true)
            case "reminder":
                let ac = UIAlertController(title: "Уведомить позже?", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
                    self!.remindLater()
                })
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(ac, animated: true)
            default:
                break
            }
        }
        completionHandler()
    }
}

















