//
//  OneTableViewCell.swift
//  NPD_GAMES
//
//  Created by DongGao on 3/6/17.
//  Copyright © 2017 TheGreatMind. All rights reserved.
//

import UIKit

class OneTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    //image data
    var images:[String] = []
    var didCollectionViewCellSelect: (([Int]) -> Void)?
    
    var selectCells: [Int:IndexPath] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //设置collectionView的代理
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // 注册CollectionViewCell
        self.collectionView!.register(UINib(nibName:"OneCollectionViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "oneCollectionCell")
        self.collectionView.allowsMultipleSelection = false
    }
    
    
    //加载数据
    func reloadData(title:String, images:[String]) {
        //设置标题
        self.titleLabel.text = title
        self.titleLabel.font = UIFont(name: "Avenir-Medium", size: 18)
        //保存图片数据
        self.images = images
        
        //collectionView重新加载数据
        self.collectionView.reloadData()
        
        
        //更新collectionView的高度约束
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        collectionViewHeight.constant = contentSize.height
    }
    
    //返回collectionView的单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    //返回对应的单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "oneCollectionCell", for: indexPath) as! OneCollectionViewCell
        cell.imageView.image = UIImage(named: images[indexPath.item])
        if selectCells[collectionView.tag] != indexPath {
            cell.layer.borderWidth = 0.0
            cell.layer.borderColor = nil
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! OneCollectionViewCell
        if cell.isSelected == true {
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.red.cgColor
            if let didCollectionViewCellSelect = didCollectionViewCellSelect {
                var select: [Int] = []
                select.append(collectionView.tag)
                select.append(indexPath.row)
                didCollectionViewCellSelect(select)
                selectCells[collectionView.tag] = indexPath
                
            }
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? OneCollectionViewCell else {
            return //the cell is not visible
        }
        
        cell.layer.borderWidth = 0.0
        cell.layer.borderColor = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //绘制单元格底部横线
    override func draw(_ rect: CGRect) {
        //线宽
        let lineWidth = 1 / UIScreen.main.scale
        //线偏移量
        let lineAdjustOffset = 1 / UIScreen.main.scale / 2
        //线条颜色
        let lineColor = UIColor.white
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //创建一个矩形，它的所有边都内缩固定的偏移量
        let drawingRect = self.bounds.insetBy(dx: lineAdjustOffset, dy: lineAdjustOffset)
        
        //创建并设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.maxY))
        
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置笔触宽度
        context.setLineWidth(lineWidth)
        
        //绘制路径
        context.strokePath()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }

    
}
