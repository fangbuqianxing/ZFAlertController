//
//  ZFAlertController.swift
//  test13
//
//  路漫漫其修远兮 吾将上下而求索
//  Created by 张玉飞 on 2020/1/7  11:15 AM.
//  Copyright © 2020 tataufo. All rights reserved.
//
	
import UIKit
import SnapKit

class ZFAlertAction: NSObject {

    /// The title of the action’s button.
    var title: String?
    
    /// 带属性的title字符串 如果此属性有值 设置的title将被忽略掉
    var titleAttributed: NSAttributedString?
    
    /// 字体颜色 默认黑色
    var titleColor: UIColor = UIColor.black
    /// 字体大小 默认字体大小粗体24号
    var font: UIFont = UIFont.boldSystemFont(ofSize: 24)
    
    /// 指定图片的名字
    var imageName: String?
    
    /// how to position content horizontally inside control. default is left
    var contentAlignment: UIControl.ContentHorizontalAlignment = .left
    
    /// A Boolean value indicating whether the action is currently enabled. The default value of this property is true. Changing the value to false causes the action to appear dimmed in the resulting alert. When an action is disabled, taps on the corresponding button have no effect.
    var isEnabled: Bool = true
    
    /// handler A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    var handler: ((ZFAlertAction) -> Void)?
    
    /// 行高
    var height: CGFloat = 60
    
    /// 自定义View 的类类型 内部调用 init(frame: CGRect)初始化实例对象
    var customViewType: ZFActionView.Type?
    
    /// Create and return an action with the specified title and behavior.
    /// - Parameters:
    ///   - title: The text to use for the button title.
    ///   - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    init(title: String? = nil, handler: ((ZFAlertAction) -> Void)? = nil) {
        
        self.title = title
        self.handler = handler
        super.init()
    }
    
    private var tempHandler: ((_ handler: @escaping (() -> Void)) -> Void)?
    func addTarget(_ handler: @escaping (_ handler: @escaping (() -> Void)) -> Void) -> ZFActionView {
        tempHandler = handler
        let frame = CGRect(x: 0, y: 0, width: 375, height: height)
        
        let control = customViewType?.init(frame: frame) ?? ZFButton(type: .custom)
        control.addTarget(self, action: #selector(handlerAction), for: .touchUpInside)
        control.setData(action: self)
        
        return control
    }
    
    @objc private func handlerAction() {
        tempHandler? { [weak self] in
            guard let self = self else { return }
            self.handler?(self)
        }
    }
}
/// 自定义view要遵守的协议
protocol ZFActionView: UIControl {
    /// 设置数据
    func setData(action: ZFAlertAction)
}
/// 默认的actionView
class ZFButton: UIButton {}
extension ZFButton: ZFActionView {
    
    func setData(action: ZFAlertAction) {
    
        if let titleAttributed = action.titleAttributed {
            self.setAttributedTitle(titleAttributed, for: .normal)
        } else {
            self.setTitle(action.title, for: .normal)
        }
        if let name = action.imageName {
            self.setImage(UIImage(named: name), for: .normal)
        }
        
        titleLabel?.font = action.font
        self.setTitleColor(action.titleColor, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.contentHorizontalAlignment = action.contentAlignment
    }
}

class ZFAlertController: UIViewController {
    /// 模糊背景view
    private let blurEffectView: UIVisualEffectView
    /// 所有子view 添加在此view上 此view添加在模糊view的contentView上
    private let contentView = UIControl()
    /// 展示actionView 的父view
    private let content = UIView()
    /// 内容背景颜色 默认是透明
    var backgroundColor: UIColor = UIColor.clear
    /// A bitmask value that identifies the corners that you want rounded. You can use this parameter to round only a subset of the corners of the rectangle.
    var corners: UIRectCorner = [.topLeft, .topRight]
    /// content的圆角半径 默认值为零
    var cornerRadius: CGFloat = 0
    /// 是否需要取消按钮 默认需要
    var containCancel: Bool = true
    /// 所有的展示点击行为模型数组
    var actions = [ZFAlertAction]()

    init(title: String?, blurStyle: UIBlurEffect.Style = .light) {
         
        let blurEffect = UIBlurEffect(style: blurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.main.bounds
        
        super.init(nibName: nil, bundle: nil)
        self.title = title
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if containCancel {
            let cancelAction = ZFAlertAction()
            cancelAction.imageName = "close"
            cancelAction.contentAlignment = .center
            actions.append(cancelAction)
        }
        
        setupSubviews()
    }
    
    private var tempButton: ZFActionView?
    private func setupSubviews() {
        
        view.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        contentView.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        blurEffectView.contentView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        content.backgroundColor = backgroundColor
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        let maskPath = UIBezierPath.init(roundedRect: content.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        content.layer.mask = maskLayer
        
        var labelHeight: CGFloat = 0
        if let title = self.title, !title.isEmpty {
            labelHeight = 60
        }
        
        content.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(labelHeight)
            make.top.equalToSuperview().offset(cornerRadius)
        }
        
        let last = actions.last
        for action in actions {
            
            let button = action.addTarget {[weak self] (handler) in
                if let self = self {
                    self.dismiss(animated: true, completion: handler)
                } else {
                    handler()
                }
            }
            
            content.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(action.height)
                make.top.equalTo(tempButton == nil ? titleLabel.snp.bottom : tempButton!.snp.bottom)
                if action == last {
                    make.bottom.equalToSuperview().offset(-10)
                }
            }
            
            tempButton = button
        }
        
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let maskLayer = content.layer.mask as? CAShapeLayer {
            
            let maskPath = UIBezierPath.init(roundedRect: content.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            maskLayer.path = maskPath.cgPath
        }
    }
    
    func addAction(_ action: ZFAlertAction) {
        
        actions.append(action)
    }

    @objc private func cancel() {
        super.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        
        var bottom = self.view.safeAreaInsets.bottom
        bottom = (bottom > 0) ? bottom : 10
        tempButton?.snp.updateConstraints { (make) in
            make.bottom.equalTo(-bottom)
        }
    }
}
