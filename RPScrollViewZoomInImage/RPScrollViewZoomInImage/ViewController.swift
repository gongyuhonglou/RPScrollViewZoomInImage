//
//  ViewController.swift
//  RPScrollViewZoomInImage
//
//  Created by rpweng on 2019/1/28.
//  Copyright © 2019 rpweng. All rights reserved.
//
// 实现下拉时背景图片放大效果（仿QQ个人资料页面）

/*
 当下拉页面时，背景图片会随着偏移量的增加而放大。
 实现方法:
    在滚动视图（scrollView）的 scrollViewDidScroll 响应方法中获取偏移量，并根据偏移量来动态改变 imageView 的位置和尺寸。
 */

import UIKit

let screenWidth = UIScreen.main.bounds.width // 屏幕宽度
let screenHeight = UIScreen.main.bounds.height  // 屏幕高度

class ViewController: UIViewController {
    
    var imageView: UIImageView! // 图片视图
    let imageViewHeight: CGFloat = 200 // 图片默认高度
    
    var tableView: UITableView! //表格视图
    let rowNumber = 50 // 表格数据条目数
    let rowHeight: CGFloat = 40 // 表格行高
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 首先创建一个滚动视图，图片还是tableView都放在这个滚动视图中
        let scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: screenWidth,
                                        height: CGFloat(rowNumber) * rowHeight + imageViewHeight)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        // 初始化图片视图
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: 0, y: 0, width: screenWidth,
                                      height: imageViewHeight)
        self.imageView.image = UIImage(named: "FemaleEmperor.jpg")
        self.imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(self.imageView)
        
        //创建表视图
        self.tableView = UITableView(frame: CGRect(x: 0, y: imageViewHeight,
                                                   width: screenWidth, height: CGFloat(rowNumber) * rowHeight), style:.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = CGFloat(rowHeight)
        self.tableView.isScrollEnabled = false
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "tableViewCell")
        scrollView.addSubview(self.tableView!)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取偏移量
        let offset = scrollView.contentOffset.y
        // 改变图片大小
        if offset <= 0 {
            self.imageView.frame = CGRect(x: 0, y: offset, width: screenWidth,
                                          height: imageViewHeight - offset)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //在本例中，有1个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return rowNumber
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "tableViewCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
            cell.textLabel?.text = "滚动啊：第\(indexPath.row + 1)行"
            cell.accessoryType = .disclosureIndicator
            return cell
    }
}

