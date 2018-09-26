const config = require("config.js");

const formatTime = date => {
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}
//网络请求
function requestPost(parameters = {}, success, showHUD = true) {

  var timestamp = Date.parse(new Date());

  parameters["AppId"] = "758120306327";
  parameters["AppKey"] = "faf4fa88935d4d2bbadd9dbe10f9d5f2";
  parameters["TimeStamp"] = timestamp;

  console.log(parameters);

  wx.request({
    url: config.Release,
    data: parameters,
    method: "POST", // OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT
    header: {
      'content-type': 'application/x-www-form-urlencoded' // 默认值
    },
    success: function(res) {
      // 接口调用成功的回调函数
      console.log(res);
      let data = res.data;
      let errcode = data.errcode;

      if (errcode == "00000") {
        success(res.data.data);

        if (showHUD) {
          hideToast();
        }
      } else {
        if (showHUD) {
          showError(data.errmsg);
        }
      }
    },
    fail: function() {
      // fail 接口调用失败的回调函数
      if (showHUD) {
        showError("网络异常");
      }
    },
    complete: function() {
      // complete 接口调用结束的回调函数
    }
  })
}

//HUD 
//成功提示
function showSuccess(title = "请求成功", duration = 2000) {
  wx.showToast({
    title: title,
    icon: 'success',
    duration: (duration <= 0) ? 2000 : duration
  });
}

function showError(title = "请求失败") {

  wx.showToast({
    title: title,
    icon: 'none'
  })
}

function showToos(title = "异常提示") {
  wx.showToast({
    title: title,
    icon: 'none'
  })
}

//loading提示
function showLoading(title = "请稍后", duration = 2000) {
  wx.showToast({
    title: title,
    icon: 'loading',
    mask: true,
    duration: (duration <= 0) ? 2000 : duration
  });
}
//隐藏提示框
function hideToast() {
  wx.hideToast();
}

//显示带取消按钮的消息提示框
function alertViewWithCancel(title = "提示", content = "消息提示", confirm, showCancel = "true") {
  wx.showModal({
    title: title,
    content: content,
    showCancel: showCancel,
    success: function(res) {
      if (res.confirm) {
        confirm();
      }
    }
  });
}
//显示不取消按钮的消息提示框
function alertView(title = "提示", content = "消息提示", confirm) {
  alertViewWithCancel(title, content, confirm, false);
}



module.exports = {
  formatTime: formatTime,
  requestPost: requestPost,
  showSuccess: showSuccess,
  showLoading: showLoading,
  hideToast: hideToast,
  alertViewWithCancel: alertViewWithCancel,
  alertView: alertView,
  showToos: showToos
}