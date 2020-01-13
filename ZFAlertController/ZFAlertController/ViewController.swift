//
//  ViewController.swift
//  ZFAlertController
//
//  路漫漫其修远兮 吾将上下而求索
//  Created by 张玉飞 on 2020/1/7  4:16 PM.
//  Copyright © 2020 tataufo. All rights reserved.
//
	

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255.0,
                                       green: CGFloat(arc4random_uniform(256))/255.0,
                                       blue: CGFloat(arc4random_uniform(256))/255.0,
                                       alpha: 1)
        
        let imageView = UIImageView(image: UIImage(named: "1"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(self.view.snp.centerY)
        }
        
        let imageView2 = UIImageView(image: UIImage(named: "2"))
        view.addSubview(imageView2)
        imageView2.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(self.view.snp.centerY)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let controller = ZFAlertController(title: nil)

        let one = ZFAlertAction(title: "查看资料") { (action) in
            print(action.title ?? "one title")
        }
        controller.addAction(one)

        let two = ZFAlertAction(title: "举报") { (action) in
            print(action.title ?? "two title")
        }
        controller.addAction(two)
        
        let delete = ZFAlertAction(title: "删除会话") { (action) in
            print(action.title ?? "delete")
        }
        controller.addAction(delete)
        
        self.present(controller, animated: true, completion: nil)
        
        let controller1 = ZFAlertController(title: "啦啦啦 卖报啦🌶")
        controller1.addAction(one)
        controller1.addAction(two)
        controller1.addAction(delete)
        controller1.backgroundColor = UIColor.white
        controller1.cornerRadius = 20
        
        let a1 = ZFAlertAction(title: nil) { (action) in
            print(action.title ?? "delete")
        }
        a1.titleAttributed = NSAttributedString(string: "属性字符串", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
        controller1.addAction(a1)
        
        let a2 = ZFAlertAction(title: "自定义view") { (action) in
            print(action.title ?? "自定义view")
        }
        a2.customViewType = ZFCustomViewOne.self
        a2.imageName = "close"
        a2.contentAlignment = .center
        a2.height = 100
        controller1.addAction(a2)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            controller.present(controller1, animated: true, completion: nil)
        }
    }

}

