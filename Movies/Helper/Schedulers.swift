//
//  Schedulers.swift
//  Movies
//
//  Created by Alan Jeferson on 16/03/2018.
//  Copyright © 2018 ajeferson. All rights reserved.
//

import Foundation
import RxSwift

struct Schedulers {
    
    static let io: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global(qos: .utility))
    static let main: ImmediateSchedulerType = MainScheduler.instance
    static let current: ImmediateSchedulerType = CurrentThreadScheduler.instance
    
}
