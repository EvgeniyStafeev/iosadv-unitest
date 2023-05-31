//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 17.05.2023.
//

import UserNotifications

protocol LocalNotificationsProtocol {
    func registerForLatestUpdatesIfPossible()
}


final class LocalNotificationsService: LocalNotificationsProtocol {

    func registerForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .badge, .provisional]) { [weak self] success, error in
            if success {
                self?.sheduleNotification()
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }

    private func sheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Давно не виделись"
        content.body = "Посмотрите последние обновления"

        var components = DateComponents()
        components.hour = 19
//        components.minute = 0
//        components.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: "everyDay", content: content, trigger: trigger)

        center.add(request)
    }

}
