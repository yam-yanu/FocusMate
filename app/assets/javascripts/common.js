$(function(){
	datetimepicker_helper();
	more_load();
});
//モバイル使用時,ページ遷移にアニメーションをつける
$(document).on({
	'page:fetch':function(){
		if(!$(".mobile")[0]) return;
		sidebar_close();
		$('.mobile').animate({marginLeft:'-=' + $(window).width() + 'px',opacity:'0'},500);
		show_loading();
	},'page:load':function(){
		more_load();
		datetimepicker_helper();
		if(!$(".mobile")[0]) return;
		$('.mobile').css({display:'block',marginLeft:$(window).width(),opacity:'0'});
		$('.mobile').animate({marginLeft:'0px',opacity:'1'},500);
	},'page:restore':function(){
		if(!$(".mobile")[0]) return;
		$('.mobile').css({display:'block',marginLeft:'-=' + $(window).width() + 'px',opacity:'0'});
		$('.mobile').animate({marginLeft:'0px',opacity:'1'},500);
		$(".loading_spin").remove();
	}
});

//サイドバー関連（ボタンとフリック）
jQuery.fx.interval = 1; //jqueryアニメーションのfpsを設定
var isSidebarOpen = false;
var screen_width = window.innerWidth;
var sidebar_width = $(".right_bar_mobile").width();
//ボタンクリックでサイドバー開く
$(document).on('click touchstart','#showRightPush',function(){
	if(isSidebarOpen == false){
		sidebar_open();
	}else{
		sidebar_close();
	}
});
//サイドバー開く
function sidebar_open(){
	var sidebar_width = $(".right_bar_mobile").width();
	var screen_width = window.innerWidth;
	$("#main-column").animate({left: -sidebar_width},{duration: 'normal',easing: 'swing'});
	$(".navbar-mobile-top").animate({left: -sidebar_width},{duration: 'normal',easing: 'swing'});
	$(".navbar-mobile-bottom").animate({left: -sidebar_width},{duration: 'normal',easing: 'swing'});
	$(".right_bar_mobile").animate({left: (screen_width - sidebar_width)},{duration: 'normal',easing: 'swing'});
	isSidebarOpen = true;
}
//サイドバー閉じる
function sidebar_close(){
	var sidebar_width = $(".right_bar_mobile").width();
	$("#main-column").animate({left: "0%"},{duration: 'normal',easing: 'swing'});
	$(".navbar-mobile-top").animate({left: "0%"},{duration: 'normal',easing: 'swing'});
	$(".navbar-mobile-bottom").animate({left: "0%"},{duration: 'normal',easing: 'swing'});
	$(".right_bar_mobile").animate({left: "100%"},{duration: 'normal',easing: 'swing'});
	isSidebarOpen = false;
}
//サイドバーが開いてる時、フリックで閉じれるようにする
$(document)
	/* フリック開始 */
	.on('touchstart','#main-column',function(e){
		if(!isSidebarOpen) return; //サイドバーが表示されていないときは発動しない
		this.touchX = event.changedTouches[0].pageX; //前のタッチ座標を保持
		this.mainX = $(this).position().left; //メインカラムの座標を保持
		this.sidebarX = $(".right_bar_mobile").position().left; //サイドバーの座標を保持
		this.slideX = 0; //前の瞬間から今の時点までのフリックの量を保持
		this.all_slideX = 0; //フリック量の合計を保持
	/* フリック中 */
	}).on('touchmove','#main-column',function(e){
		if(!isSidebarOpen) return;
		e.preventDefault(); //フリック中は縦スクロールなどをしない
		this.slideX = event.changedTouches[0].pageX - this.touchX; //どのくらいフリックしたか計算(右フリックが＋の値)
		if(this.all_slideX + this.slideX < 0) return; //合計フリック量を見て左フリックになるようなら抜ける
		this.all_slideX += this.slideX;
		this.accel = (event.changedTouches[0].pageX - this.touchX) * 3; //加速度を計算する(重み付け入り)
		//console.log("速度：" + this.accel +" 合計フリック量：" + this.all_slideX);
		this.touchX = event.changedTouches[0].pageX;
		//合計フリック量を使ってそれぞれのcssを変更
		$(this).css({left:(this.mainX + this.all_slideX)});
		$(".navbar-mobile-top").css({left:(this.mainX + this.all_slideX)});
		$(".navbar-mobile-bottom").css({left:(this.mainX + this.all_slideX)});
		$(".right_bar_mobile").css({left:(this.sidebarX+this.all_slideX)});
	/* フリック終了 */
	}).on('touchend','#main-column',function(e){
		if(!isSidebarOpen) return;
		if(this.all_slideX < 0) return;
		this.all_slideX += this.accel;
		//加速度込みの合計フリック量によってサイドバーを隠すかそのままにしておくか決める
		if (this.all_slideX < (sidebar_width/2) ) {
			/*処理１　サイドバーあるまま(フリック前の状態を復元)*/
			$(this).animate({left:this.mainX},500);
			$(".navbar-mobile-top").animate({left:this.mainX},500);
			$(".navbar-mobile-bottom").animate({left:this.mainX},500);
			$(".right_bar_mobile").animate({left:this.sidebarX},500);
		}else{
			/*処理2　全体を右にずらしてサイドバーを隠す*/
			$(this).animate({left:"0%"},(500 - this.accel*5),"linear");
			$(".navbar-mobile-top").animate({left:"0%"},(500 - this.accel*5),"linear");
			$(".navbar-mobile-bottom").animate({left:"0%"},(500 - this.accel*5),"linear");
			$(".right_bar_mobile").animate({left:"100%"},(500 - this.accel*5),"linear");
			isSidebarOpen = false;
			this.accel = 0;
		}
});

//行動の記述をajaxで追加
$(document).on('click','#prize_submit',function(){
	console.log("fsdfasdf");
	if( $("#action_where").val() == "" || $("#action_what").val() == "" || $("#action_date").val() == "" || $("#action_time").val() == ""){
		alert("入力していない項目があります");
		return;
	}else if($("#action_who").val() == $("#action_author").val()){
		alert("自分のことを褒めることは出来ません");
		return;
	}
	$.ajax({
		type: 'post',
		url: '/actions',
		data: {who : $("#action_who").val(),
				date: $("#action_date").val(),
				time: $("#action_time").val(),
				where: $("#action_where").val(),
				what: $("#action_what").val(),
				author: $("#action_author").val()
				},
		success: function(one_action){
			console.log(one_action);
			$('#prizeModal').modal('hide');
			$("#action_where").val("");
			$("#action_what").val("");
			$("#no_action_message").remove();
			$(".new_action").prepend(one_action);
			$(".new_action .well:first").css('opacity','0');
			$('.new_action .well:first').animate({opacity:'1'},1000);
		},
		error: function(){
			console.log("fails");
			alert("通信エラー！もう少し時間をおいて試してみてください。");
			$('#prizeModal').modal('hide');
		}
	});
});

//褒めるの日付フォーム部をカレンダーにする+時刻フォームを操作しやすくする
function datetimepicker_helper(){
	$('#action_date').datepicker({
		format:"yyyy/mm/dd",
		language:"ja",
		autoclose: true,
		startDate: "-1m",
		endDate:Date(),
		todayHighlight : true,
	});
	//フォームに今日の日付を入れる
	$("#action_date").val(new DateFormat("yyyy/MM/dd").format(new Date()));
	//日付フォームにフォーカスがあたった時、カレンダーを前面に出す
	$('#action_date').on('show', function(){
		$("div.datepicker.dropdown-menu").css("z-index","10000");
		$("div.datepicker.dropdown-menu").css("left",((window.innerWidth - $("div.datepicker.dropdown-menu").width())/2));
	});
	//カレンダーでの日付選択が行われたとき、timepickerを発動
	$('#action_date').on('changeDate', function(){
		$('#action_time').timepicker('showWidget');
	});
	$('#action_time').timepicker({
		minuteStep:10,
		showMeridian:false
	});
	//時刻フォームにフォーカスがあたった時、cssを適切に設定し直す
	$('#action_time').on('show.timepicker', function(){
		$(".bootstrap-timepicker-widget").css("z-index","10000");
		$(".bootstrap-timepicker-hour").removeClass("form-control");
		$(".bootstrap-timepicker-minute").removeClass("form-control");
		$(".bootstrap-timepicker-hour").css("border","none");
		$(".bootstrap-timepicker-minute").css("border","none");
		$(".bootstrap-timepicker-widget table tbody").append('<tr id="timepicker-submit-tr"><td></td><td><i id="timepicker-submit" class="fa fa-check"></td><td></td></tr>');
		$('#timepicker-submit-tr').on('click', function(){
			$('#action_time').timepicker('hideWidget');
		});
	});
	$('#action_time').on('hide.timepicker', function(){
		$("#timepicker-submit-tr").remove();
	});
}

//ページの下の方に行くと続きの行動をサーバーから取ってくる
function more_load(){
	var url = location.pathname;
	var loading = false;
	$('#more')// mainの一番下に配置
		.lazyload({ threshold: 400 })// 400px 余裕をもって appear イベントを発行
		.on('appear', function () {
			if (loading) return;// 非同期通信を抑制する
			if (!$(".well:last").data("act_time")){ //一つも行動がない場合、なにもしない
				$("#more").css("display","none");
				return;
			}
			loading = true;
			$.ajax({
				type: 'get',
				url: url,
				data: {act_time: $(".well:last").data("act_time")},
			}).done(function(actions){
				if(actions == " "){
					$("#more").css("visibility","hidden");
					$("#more").css("font-size","10px");
				}else{
					$('#more').before(actions);
					loading = false;
				}
			}).fail(function(){
			});
		});
}

//ローディング中アイコンを表示する
function show_loading(){
	$("body").append('<div class=loading_spin><i class="fa fa-spinner fa-spin"></i><br>loading</div>');
}