//
//  NavViewController.swift
//  RPScrollViewZoomInImage
//
//  Created by rpweng on 2019/1/28.
//  Copyright © 2019 rpweng. All rights reserved.
//
/*
    1) 增加一个导航栏，不过默认情况下导航栏不可见。而下拉时背景图片放大效果同ViewController一样
    2) 当向上滑动页面时，背景栏会逐渐显示出来。同时在背景图快要完全移出时，导航栏标题才显示出来
 */

import UIKit

class NavViewController: UIViewController {

    //导航栏背景视图
    var barImageView: UIView?
    
    var imageView: UIImageView! // 图片视图
    let imageViewHeight: CGFloat = 200 // 图片默认高度
    
    var tableView: UITableView! //表格视图
    let rowNumber = 50 // 表格数据条目数
    let rowHeight: CGFloat = 40 // 表格行高
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取导航栏背景视图
        self.barImageView = self.navigationController?.navigationBar.subviews.first
        //修改导航栏背景色
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .orange
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        // 默认情况下导航栏全透明
        self.barImageView?.alpha = 0
    }
}

extension NavViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取偏移量
        let offset = scrollView.contentOffset.y
        // 改变图片大小
        if offset <= 0 {
            self.imageView.frame = CGRect(x: 0, y: offset, width: screenWidth,
                                          height: imageViewHeight - offset)
        }
        
        // 导航栏背景透明度改变
        var delta =  offset / (imageViewHeight - 64)
        delta = CGFloat.maximum(delta, 0)
        self.barImageView?.alpha = CGFloat.minimum(delta, 1)
        
        // 根据偏移量决定是否显示导航栏标题（上方图片快完全移出时才显示）
        self.title =  delta > 0.9 ? "Hello Swift" : ""
    }
}

extension NavViewController: UITableViewDelegate, UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identify, for: indexPath)
            cell.textLabel?.text = "往上滑啊： 第\(indexPath.row + 1)行"
            return cell
    }
}
