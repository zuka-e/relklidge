// Date()-> Sat Jan 15 2000 00:00:00 GMT+0900 (日本標準時)

$(document).on("turbolinks:load", function() {
  // グローバル変数定義
  var startTime, nowTime;
  var elapsedTime; // 経過時間
  var msec, csec, sec, min, hour;
  var mode; //  RUN or STOP
  var RUN = 1; // 動作中
  var STOP = 0; // 停止中

  // 初期化 (最初とクリア押下のタイミングで)
  var resetTimer = function() {
    mode = STOP;
    elapsedTime = msec = csec = sec = min = hour = 0;
    $("#timer_time").val("00:00:00.00");
  };
  resetTimer();

  // 00:00:00.00 表示にする
  var displayTime = function() {
    // 2桁表示へ
    var cs = "" + csec;
    if (cs.length < 2) cs = "0" + cs;
    var s = "" + sec;
    if (s.length < 2) s = "0" + s;
    var m = "" + min;
    if (m.length < 2) m = "0" + m;
    var h = "" + hour;
    if (h.length < 2) h = "0" + h;
    var strfTime = h + ":" + m + ":" + s + "." + cs;
    $("#timer_time").val(strfTime);
  };

  // 実際の時間計測を行う
  var timerId;
  function runTimer() {
    nowTime = new Date().getTime(); // from 1970年1月1日 00:00:00
    diff = new Date(nowTime - startTime);
    msec = diff.getMilliseconds();
    csec = Math.floor(msec / 10); // 引数以下の最大の整数
    sec = diff.getSeconds();
    min = diff.getMinutes();
    // getTimezoneOffset()-> 日本の場合 -540
    var gmt = new Date().getTimezoneOffset() / 60;
    hour = diff.getHours() + gmt; // 日本時間へ
    displayTime(); // 表示用関数
    timerId = setTimeout(runTimer, 10);
  }

  // スタート[ストップ]押下時
  var clickedStartStop = function() {
    switch (mode) {
      case STOP: // スタート押下
        mode = RUN;
        startTime = new Date().getTime();
        // hourなどはrunTimer()により代入
        elapsedTime =
          hour * 60 * 60 * 1000 + min * 60 * 1000 + sec * 1000 + msec;
        startTime -= elapsedTime; // 停止していた時間を差し引く
        timerId = setTimeout(runTimer, 10);
        $("#resetTimer").prop("disabled", true);
        $("#startTimer").text("ストップ");
        break;
      case RUN: // ストップ押下
        mode = STOP;
        clearTimeout(timerId);
        $("#startTimer").text("スタート");
        $("#resetTimer").prop("disabled", false);
        displayTime();
    }
  };

  $(document).on("click", "#startTimer", function() {
    clickedStartStop();
  });
  $(document).on("click", "#resetTimer", function() {
    resetTimer();
  });

  // 文字数カウント
  $(document).on("keyup mouseover", "#post_content", function() {
    var num = $(this).val().length;
    $("#count_str").text(`${num}文字`);
  });
  // 不可
  // $("#post_content").on("keyup", function() {
  //   var num = $(this).val().length;
  //   $("#count_str").text(`${num}文字`);
  // });
});
