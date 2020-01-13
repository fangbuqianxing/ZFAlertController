//
//  ZFCustomViewOne.swift
//  ZFAlertController
//
//  路漫漫其修远兮 吾将上下而求索
//  Created by 张玉飞 on 2020/1/13  5:47 PM.
//  Copyright © 2020 tataufo. All rights reserved.
//
	

import UIKit

class ZFCustomViewOne: UIControl, ZFActionView {
    
    let titleLabel = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.cyan
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        addSubview(titleLabel)
        addSubview(imageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(self.snp_centerY)
        }
        
        imageView.contentMode = .center
        imageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.snp_centerY)
        }
    }
    
    func setData(action: ZFAlertAction) {
        
        titleLabel.textAlignment = .center
        titleLabel.font = action.font
        if let titleAttributed = action.titleAttributed {
            titleLabel.attributedText = titleAttributed
        } else {
            titleLabel.text = action.title
            titleLabel.textColor = action.titleColor
        }
        
        if let imageName = action.imageName {
            imageView.image = UIImage(named: imageName)
        }
    }
}
