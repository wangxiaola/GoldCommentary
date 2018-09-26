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
    scenicPage: 1,
    guideArray: [], // 我的解说员数组
    guidePage: 1,
    guideCellHieght:160
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
  scenicCellClick: function(e){

    console.log(e.currentTarget.dataset.item.name);
  },
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function() {


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

  requestPostBaseData:function (){
    var that = this;
    var parameters = {
      "id": "25689",
      "interfaceId": "298",
    };

    util.requestPost(parameters, function (res) {
  
      let last = res.last ? res.last:"0.00";
      let balance = res.balance ? res.balance:"0.00";
      that.setData({
        earnings:last,
        balance:balance
      })

    },false)
  }
})