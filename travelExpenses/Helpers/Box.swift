//
//  Box.swift
//  report
//
//  Created by osa on 18.07.2021.
//

class Box<T> {
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    //listener захватывает новое значение с типом T при его изменении
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    //момент изменения свойства с типом T
    func bind(listener: @ escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
