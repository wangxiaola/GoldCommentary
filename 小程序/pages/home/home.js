//index.js
//获取应用实例
const app = getApp()

Page({

  /**
   * 页面的初始数据
   */
  data: {
    currentData: 0, // 当前选中
    earnings: '0.00', //收益
    balance: '0.00', //余额
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


  }
})