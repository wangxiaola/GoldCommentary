//index.js
//获取应用实例
const app = getApp()
const util = require("../../utils/util.js");
// https://www.cnblogs.com/zxf100/p/8118799.html
// http://www.php.cn/xiaochengxu-359996.html
// https://www.2cto.com/kf/201801/711549.html
Page({

  /**
   * 页面的初始数据
   */
  data: {
    currentData: 0, // 当前选中
    earnings: '0.00', //收益
    balance: '0.00', //余额 
    scenicArray: [], // 我的景区数组
    scenicPage: 1,
    guideArray: [], // 我的解说员数组
    guidePage: 1,
    guideCellHieght: 160,
    guideCellIndex: -1,
    chooseSize: false,
    animationData: {},
    chooseViewHieght: 200,
    chooseArray: [], // 提示框显示数据
    scrollY: true
  },

  onLoad: function(e) {

    this.requestPostData();
    this.requestPostBaseData();
  },
  // 触底事件
  lower: function(e) {
    const that = this;
    if (that.data.currentData == 0) {

      if (that.data.scenicArray.length % 20 == 0) {
        that.data.scenicPage += 1;
        that.requestPostData();
      } else {
        util.showToos("  数据已全部加载  ")
      }

    } else {

      if (that.data.guideArray.length % 20 == 0) {
        that.data.guidePage += 1;
        that.requestPostData();
      } else {
        util.showToos("  数据已全部加载  ")
      }
    }
  },

  /***点击事件***/
  /**
   * 滑动视图监听
   */
  bindchange: function(e) {

    const that = this;

    if (e.detail.current == 1 && that.data.guideArray.length == 0) {
      that.requestPostData();
    }
    if (e.detail.current == 0 && that.data.scenicArray.length == 0) {
      that.requestPostData();
    }

    that.setData({
      currentData: e.detail.current,
    })

  },

  /**
   * 点击选择按钮监听
   */
  checkCurrent: function(e) {

    const that = this;
    if (that.data.currentData === e.target.dataset.current) {
      return false;
    } else {
      that.setData({
        currentData: e.target.dataset.current,
      })
    }
  },

  // 我的点击
  myClick: function(sender) {

    wx.showActionSheet({
      itemList: ["稍等"],
    })
  },
  // 收入明细点击
  billClick: function(sender) {

    wx.showActionSheet({
      itemList: ["稍等"],
    })
  },
  // 提现操作
  withdrawalClick: function(sender) {

    wx.showActionSheet({
      itemList: ["稍等"],
    })
  },
  addScenicClick: function() {
    wx.showActionSheet({
      itemList: ["稍等"],
    })
  },
  // 景区cell点击回调
  scenicCellClick: function(e) {
    var that = this;
    let data = e.currentTarget.dataset;
    let dataType = data.item.state;
    let path = "../../pages/images/";
    var array = [];
    // <!--0审核中 1成功 2未通过 3已下架-- >
    if (dataType == 1) {
      array = [{
          "image": path + "scenicTooView_1.png",
          "name": "创建景点"
        },
        {
          "image": path + "scenicTooView_2.png",
          "name": "编辑景区"
        },
        {
          "image": path + "scenicTooView_3.png",
          "name": "信息采集"
        },
        {
          "image": path + "scenicTooView_4.png",
          "name": "删除景区"
        },
      ];
    } else {
      array = [{
          "image": path + "scenicTooView_2.png",
          "name": "编辑景区"
        },
        {
          "image": path + "scenicTooView_3.png",
          "name": "删除景区"
        },
      ];
    }
    // 更新布局
    that.setData({
      chooseArray: array,
      scrollY: false
    })
    //  开始动画
    this.chooseSezi();
  },
  // 景区操作事件
  scenicOperationClick: function(e) {

    let that = this;
    let scenicType = e.currentTarget.dataset.item.name;
    switch (scenicType) {
      case "创建景点":
        console.log("1");
        break;
      case "编辑景区":
        console.log("2");
        break;
      case "信息采集":
        console.log("3");
        break;
      case "删除景区":
        console.log("4");
      default:
    }
    that.hideModal();

  },
  //  禁止事件穿透
  myCatchTouch: function() {},
  // 我的解说员点击回调
  guideUpdateHeightClick: function(e) {

    let index = e.currentTarget.dataset.index;
    var that = this;
    let isSelect = index == that.data.guideCellIndex;
    //创建节点选择器
    var query = wx.createSelectorQuery();

    query.select('.guide-listView' + index).boundingClientRect(function(rect) {

      that.setData({
        guideCellHieght: rect.height < 30 ? 160 : rect.height + 160,
        guideCellIndex: isSelect ? -1 : index
      })
    }).exec();
  },
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function() {


  },
  //  动画
  // 显示弹窗
  chooseSezi: function(e) {

    var that = this;
    let offes = that.data.chooseViewHieght;
    // 创建一个动画实例
    var animation = wx.createAnimation({
      // 动画持续时间
      duration: 200,
      // 定义动画效果
      timingFunction: 'ease'
    })
    // 将该变量赋值给当前动画
    that.animation = animation
    // 先在y轴偏移，然后用step()完成一个动画
    animation.translateY(offes).step()
    // 用setData改变当前动画
    that.setData({
      // 通过export()方法导出数据
      animationData: animation.export(),
      // 改变view里面的Wx：if
      chooseSize: true
    })
    // 设置setTimeout来改变y轴偏移量，实现有感觉的滑动
    setTimeout(function() {
      animation.translateY(0).step()
      that.setData({
        animationData: animation.export()
      })
    }, 50)
  },
  // 隐藏弹窗
  hideModal: function(e) {
    var that = this;
    let offes = that.data.chooseViewHieght;
    var animation = wx.createAnimation({
      duration: 200,
      timingFunction: 'linear'
    })
    that.animation = animation
    animation.translateY(offes).step()
    that.setData({
      animationData: animation.export()

    })
    setTimeout(function() {
      animation.translateY(0).step()
      that.setData({
        animationData: animation.export(),
        chooseSize: false,
        scrollY: true
      })
    }, 50)
  },

  // 数据加载
  requestPostData: function() {
    var that = this;
    let page = that.data.currentData == 0 ? that.data.scenicPage : that.data.guidePage;
    //加载提示框
    util.showLoading();
    var parameters = {
      "id": "25689",
      "interfaceId": that.data.currentData == 0 ? "296" : "297",
      "page": page.toString(),
      "rows": "20"
    };

    util.requestPost(parameters, function(res) {
      // 数组

      var root = res.root;
      var page = that.data.currentData == 0 ? that.data.scenicPage : that.data.guidePage;
      var array = that.data.currentData == 0 ? that.data.scenicArray : that.data.guideArray;

      if (page == 1) {
        array = root;
      } else {
        array = array.concat(root);
      }

      // 如果当前选中景区
      if (that.data.currentData == 0) {

        that.setData({
          scenicArray: array
        })

      } else {
        // 如果当前选中解说员
        that.setData({
          guideArray: array
        })
      }
    });
  },

  requestPostBaseData: function() {
    var that = this;
    var parameters = {
      "id": "25689",
      "interfaceId": "298",
    };

    util.requestPost(parameters, function(res) {

      let last = res.last ? res.last : "0.00";
      let balance = res.balance ? res.balance : "0.00";
      that.setData({
        earnings: last,
        balance: balance
      })

    }, false)
  }
})