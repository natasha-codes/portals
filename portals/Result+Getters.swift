//
//  Result+Getters.swift
//  portals
//
//  Created by Sasha Weiss on 4/5/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        return failure == nil
    }

    var isFailure: Bool {
        return success == nil
    }

    var success: Success? {
        switch self {
        case .success(let s): return s
        case .failure: return nil
        }
    }

    var failure: Failure? {
        switch self {
        case .success: return nil
        case .failure(let f): return f
        }
    }
}
