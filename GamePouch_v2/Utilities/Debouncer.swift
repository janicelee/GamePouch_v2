//
//  Debouncer.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-06.
//

import Foundation

func debounce(interval: Int, action: @escaping (() -> Void)) -> () -> Void {
    var lastFireTime = DispatchTime.now()
    let dispatchDelay = DispatchTimeInterval.milliseconds(interval)
    
    return {
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now = DispatchTime.now()
            
            if now.rawValue >= when.rawValue {
                action()
            }
        }
    }
}
