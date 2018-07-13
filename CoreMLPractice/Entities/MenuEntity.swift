//
//  MenuEntity.swift
//  CoreMLPractice
//
//  Created by Yoshikazu Ando on 2018/07/13.
//  Copyright © 2018年 Yoshikazu Ando. All rights reserved.
//

import UIKit
import Foundation

struct MenuEntity {
    let title: String
    let className: String

    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: self.className, bundle: nil)

        guard let controller = storyboard.instantiateInitialViewController() else { fatalError() }
        controller.title = self.title

        return controller
    }
}
