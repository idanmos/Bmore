//
//  AppContext.swift
//  Bmore
//
//  Created by Idan Moshe on 01/02/2021.
//

import UIKit

protocol AppContext: class {
    var reportedApplicationState: UIApplication.State { get }
}

private var _currentAppContext: AppContext? = nil

func CurrentAppContext() -> AppContext {
    return _currentAppContext!
}

func SetCurrentAppContext(_ appContext: AppContext) {
    _currentAppContext = appContext
}
