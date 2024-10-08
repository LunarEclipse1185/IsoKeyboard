//
//  TypedNotification.swift
//  IsoKeyboard
//
//  Created by SH BU on 2024/8/17.
//

import Foundation

open class TypedNotification<ValueType: CustomStringConvertible> {
    public let name: Notification.Name
    
    init(name: String) {
        self.name = Notification.Name(name)
    }
    
    open func post(value: ValueType) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["value": value])
    }
    
    open func registerOnAny(block: @escaping (ValueType) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { note in
            guard let value = note.userInfo?["value"] as? ValueType else { fatalError("Couldn't understand user info") }
            block(value)
        }
    }
    
    open func registerOnMain(block: @escaping (ValueType) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { note in
            guard let value = note.userInfo?["value"] as? ValueType else { fatalError("TypedNotification recieved inconsistent type") }
            DispatchQueue.main.async {
                block(value)
            }
        }
    }
}
