//
//  Schedulers.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

typealias Scheduler = ImmediateSchedulerType

struct Schedulers {
    
    static let io: Scheduler = ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global(qos: .utility))
    static let main: Scheduler = MainScheduler.instance
    static let current: Scheduler = CurrentThreadScheduler.instance
    
}
