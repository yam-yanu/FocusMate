$(function(){
	datetimepicker_helper();
	more_load();
	update_users();
	$('#group_modal').modal();
});
//モバイル使用時,ページ遷移にアニメーションをつける
$(document).on({
	'page:fetch':function(){
		if(!$(".mobile")[0]) return;
		change_screen_state(CENTER_SCREEN);
		$('.mobile').animate({marginLeft:'-=' + $(window).width() + 'px',opacity:'0'},500);
		show_loading();
	},'page:load':function(){
		more_load();
		datetimepicker_helper();
		$('#group_modal').modal();
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
var screen_state = 0;
const LEFT_SCREEN = -1;
const CENTER_SCREEN = 0;
const RIGHT_SCREEN = 1;
//ボタンクリックでサイドバー開く
$(document).on('touchstart','#showLeftPush',function(){
	if(screen_state != LEFT_SCREEN){
		change_screen_state(LEFT_SCREEN);
	}else{
		change_screen_state(CENTER_SCREEN);
	}
});
$(document).on('touchstart','#showRightPush',function(){
	if(screen_state != RIGHT_SCREEN){
		change_screen_state(RIGHT_SCREEN);
	}else{
		change_screen_state(CENTER_SCREEN);
	}
});
//サイドバー開く
function change_screen_state(next_screen_state){
	var moving_distance = 0;
	if((next_screen_state - screen_state) == 0){
		return false;
	}else if(Math.abs(next_screen_state - screen_state) == 2){
		change_screen_state(CENTER_SCREEN);
		change_screen_state(next_screen_state);
		return false;
	}else if(next_screen_state == 1 || screen_state == 1){
		moving_distance = (screen_state - next_screen_state)*$(".right_bar_mobile").width();
	}else if(next_screen_state == -1 || screen_state == -1){
		moving_distance = (screen_state - next_screen_state)*$(".left_bar_mobile").width();
	}
	$(".left_bar_mobile,.right_bar_mobile").animate({left: '+='+moving_distance+'px'},{duration: 'normal',easing: 'swing'});
	screen_state = next_screen_state;
	return true;
	//$(".navbar-mobile-bottom").animate({left: '+='+moving_distance+'px'},{duration: 'normal',easing: 'swing'});
}

//サイドバーが開いてる時、フリックで閉じれるようにする
$(document)
	/* フリック開始 */
	.on('touchstart','#main-column',function(e){
		if(screen_state == CENTER_SCREEN) return; //サイドバーが表示されていないときは発動しない
		this.touchX = event.changedTouches[0].pageX; //前のタッチ座標を保持
		this.mainX = $(this).position().left; //メインカラムの座標を保持
		if(screen_state == LEFT_SCREEN){//サイドバーの座標を保持
			this.sidebarX = $(".left_bar_mobile").width();
		}else if(screen_state == RIGHT_SCREEN){
			this.sidebarX = $(".right_bar_mobile").width();
		}
		this.slideX = 0; //前の瞬間から今の時点までのフリックの量を保持
		this.all_slideX = 0; //フリック量の合計を保持
	/* フリック中 */
	}).on('touchmove','#main-column',function(e){
		this.slideX = event.changedTouches[0].pageX - this.touchX; //どのくらいフリックしたか計算(右フリックが＋の値)
		if(screen_state == CENTER_SCREEN){ return; //サイドバーが表示されていないときは発動しない
		}else if(screen_state == LEFT_SCREEN && (this.all_slideX + this.slideX) > 0){ return;
		}else if(screen_state == RIGHT_SCREEN && (this.all_slideX + this.slideX) < 0){ return;
		}
		e.preventDefault(); //フリック中は縦スクロールなどをしない
		this.all_slideX += this.slideX;
		this.accel = (event.changedTouches[0].pageX - this.touchX) * 3; //加速度を計算する(重み付け入り)
		this.touchX = event.changedTouches[0].pageX;
		//合計フリック量を使ってそれぞれのcssを変更
		$(".left_bar_mobile,.right_bar_mobile").css({left: '+='+this.slideX+'px'});
	/* フリック終了 */
	}).on('touchend','#main-column',function(e){
		if(screen_state == CENTER_SCREEN) return; //サイドバーが表示されていないときは発動しない
		//加速度込みの合計フリック量によってサイドバーを隠すかそのままにしておくか決める
		if(screen_state == LEFT_SCREEN && (this.all_slideX + this.accel) < -($(".left_bar_mobile").width())/2){
			moving_distance = -$(".left_bar_mobile").width() - this.all_slideX;
			screen_state = CENTER_SCREEN;
		}else if(screen_state == RIGHT_SCREEN && (this.all_slideX + this.accel) > $(".right_bar_mobile").width()/2){
			moving_distance = $(".right_bar_mobile").width() - this.all_slideX;
			screen_state = CENTER_SCREEN;
		}else{
			moving_distance = -this.all_slideX;
		}
		$(".left_bar_mobile,.right_bar_mobile").animate({left: '+='+moving_distance+'px'},{duration: 'normal',easing: 'swing'});
		moving_distance = 0;
});
//行動した人を追加
$(document).on('click','.plus_actor',function(){
	var select_actor = $(this).parent("td").prev("td").find(".one_select:first-child").clone();
	var target_td = $(this).parent("td").prev("td");
	target_td.children(".who_select").append(select_actor);
	target_td.find(".one_select:last-child").append('<i class="fa fa-minus-circle delete_actor"></i>');
	duplicate_actor_check();
	//新しく追加したセレクトに適切な値をセットする
	target_td.find(".one_select:last-child option").each(function(){
		if(!$(this).attr("disabled")){
			$(this).parent("select").val($(this).val());
			$(this).attr("selected","selected");
			console.log($(this).parent("select").val());
			return false;
		}
	});

	//人数分selectを出したらプラスを消す
	if(target_td.find(".one_select").length >= target_td.children(".who_select").data("user_count")){
		$(this).remove();
	}
});
//行動した人を削除
$(document).on('click','.delete_actor',function(){
	//プラスが消えていたら復活させる
	if($(".plus_actor").size() == 0){
		$(this).closest("td").next("td").append('<i class="fa fa-plus-circle plus_actor" style="font-size: 20px; padding-left: 8px;"></i>');
	}
	$(this).parent(".one_select").remove();
	duplicate_actor_check();
});

//複数人を褒めるときに行動した人が重複しないようにする
$(document).on('change','#prize_form select',function(){
	duplicate_actor_check();
});
function duplicate_actor_check(){
	$("form#prize_form select option").removeAttr("disabled");
	$("form#prize_form select").each(function(){
		var checked_user_id = $(this).val();
		if(checked_user_id){
			$("form#prize_form select option[data-user_id="+checked_user_id+"]").attr("disabled","disabled");
			$(this).children("option[data-user_id="+checked_user_id+"]").removeAttr("disabled");
			console.log($(this).val());
		}
	});
}

//行動の記述をajaxで追加
$(document).on('click','#prize_submit',function(){
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
		data: $("form#prize_form").serialize(),
		success: function(one_action){
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

//ユーザーリストのログイン時間を更新する
function update_users(){
	$.ajax({
		type: 'get',
		url: '/update_users',
		dataType:'text',
	}).done(function(users){
		try{
			users_json = $.parseJSON(users);
			$.each(users_json,function(index,user){
				var one_tr = $(".user_information[data-id='"+user.id+"']");
				var latest_logined_at = user.updated_at/3600;
				if(latest_logined_at < 1){
					one_tr.children('td:last').html(parseInt(user.updated_at/60)+"分前");
				}else if(latest_logined_at <= 24){
					one_tr.children('td:last').html(parseInt(latest_logined_at)+"時間前");
				}
				if(one_tr.data("passed_time") > user.updated_at){
					var updated_at = user.updated_at;
					$(".user_information").each(function(){
						if($(this).data("passed_time") > updated_at){
							$(this).before(one_tr);
							one_tr.css('opacity','0');
							one_tr.animate({opacity:'1'},500);
							return false;
						}
					});
				}
				one_tr.data("passed_time",user.updated_at);
			});
		}catch(e){
			console.log(e);
		}
	}).fail(function(){
	});
	window.setTimeout("update_users()",30000);
}