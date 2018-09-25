//index.js
//获取应用实例
const app = getApp()
const util = require("../../utils/util.js");

Page({

  /**
   * 页面的初始数据
   */
  data: {
    currentData: 0, // 当前选中
    earnings: '0.00', //收益
    balance: '0.00', //余额 
    scenicArray: [], // 我的景区数组
    scenicPage: 0
  },

  onLoad: function(e) {

    this.requestPostData();
  },

  upper: function(e) {
    console.log("上")
  },
  lower: function(e) {
    console.log("下")
  },

  /***点击事件***/
  /**
   * 滑动视图监听
   */
  bindchange: function(e) {

    const that = this;
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
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function() {


  },
  // 数据加载
  requestPostData: function() {

    //加载提示框
    util.showLoading();    
    var parameters = {
      "id": "25689",
      "interfaceId": "296",
      "page": that.data.scenicPage += 1,
      "rows": "20"
    };

    util.requestPost(parameters, function(res) {
      var that = this;
      // 数组
      var root = res.root;

      if (that.data.scenicPage == 1) {

        that.setData({
  
          scenicArray: root
        })

      } else {

      }

    });
  },

})