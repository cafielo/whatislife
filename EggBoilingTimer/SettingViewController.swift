//
//  SettingViewController.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/03/29.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class SettingViewController: UIViewController {
    
    enum MenuType: Int, CaseIterable {
        case appVersion
        case contact
        case rate
        case recipe
        
        var title: String {
            switch self {
            case .appVersion: return "버전 \(Bundle.main.appVersion)"
            case .contact: return "꼬꼬덱 꼬꼬"
            case .rate: return "제 점수는요 😍"
            case .recipe: return
                """
                👨‍🍳 레시피
                1. 달걀이 물에 잠길 정도로 물을 받는다
                2. 식초랑 소금을 넣어 준다
                (식초를 넣으면 달걀 껍질이 얇아지고 소금을 넣으면 껍질이 잘 까지며, 삶은 도중 껍질이 깨지더라도 흰 자가 풀려나오는 것을 방지할 수 있다)
                3. 끓인다
                4. 타이머가 완료되면 찬물에 삶은 달걀을 넣어준다
                
                👩‍🍳 신선한 달걀 고르기
                달걀에는 날짜가 찍혀 있어요~ 산란일 표시제를 확인하세요
                """

            }
        }
        
        var height: CGFloat {
            switch self {
            case .recipe : return 300
            default: return 78
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let menu = MenuType(rawValue: indexPath.row) else { return 78 }
        
        return menu.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell  else {
            return UITableViewCell()
        }
        cell.menuTitle.text = MenuType.allCases[indexPath.row].title
        return cell
    }
}


extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = MenuType(rawValue: indexPath.row) else { return }
        switch menu {
        case .appVersion: break
        case .contact:
            guard MFMailComposeViewController.canSendMail() else { return }
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["awesomejoonwon@gmail.com"])
            mailComposeViewController.setSubject("Feedback💪")
            present(mailComposeViewController, animated: true, completion: nil)
        case .rate:
            SKStoreReviewController.requestReview()
        case .recipe: break
            
        }
    }
}


extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var menuTitle: UILabel!
}


extension Bundle {
    var appVersion: String {
        guard let infoDic = infoDictionary, let version = infoDic["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}
