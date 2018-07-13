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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let controller = storyboard.instantiateViewController(withIdentifier: self.className)
        controller.title = self.title

        return controller
    }
}
