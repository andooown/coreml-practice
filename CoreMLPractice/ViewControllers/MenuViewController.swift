//
//  MenuViewController.swift
//  CoreMLPractice
//
//  Created by Yoshikazu Ando on 2018/07/13.
//  Copyright © 2018年 Yoshikazu Ando. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTableView: UITableView!

    let menusModel = MenusModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil),
                                    forCellReuseIdentifier: "MenuTableViewCellIdentifier")
        self.menuTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = self.menusModel.menus[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(menu.viewController(), animated: true)

        self.menuTableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menusModel.menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            self.menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCellIdentifier",
                                                   for: indexPath) as? MenuTableViewCell else { fatalError() }

        let menu = self.menusModel.menus[(indexPath as NSIndexPath).row]
        cell.setMenu(menu)

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
