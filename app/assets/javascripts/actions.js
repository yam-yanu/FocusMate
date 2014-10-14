//「すごい！」をajaxで送信、反映する
$(document).on('click','button.great',function(){
	var clicked_dom = $(this);
	$.ajax({
		type: 'post',
		url: '/actions/'+$(this).data('action_id')+'/users/'+$(this).data('user_id')+'/add_great',
	}).done(function(){
		var great_badge = clicked_dom.prevAll('.badge');
		great_badge.text(Number(great_badge.text()) + 1);
		clicked_dom.prevAll('.badge').append(' <i class="fa fa-thumbs-o-up nav-icon"></i>');
		clicked_dom.replaceWith('<div class="great_info" >すでに褒めています</div>');
	});
});

//コメントをajaxで送信、反映する
$(document).on('click','i.form-control-feedback',function(eo){
	eo.stopPropagation(); //イベントが下の要素にも飛び火するのを防ぐ
	var clicked_dom = $(this);
	var comment_field = clicked_dom.prev();
	var comment = comment_field.val().replace(/[\n\r]/g, "<br>");
	var action_id = $(this).data('action_id');
	if(comment == ""){
		clicked_dom.after('<div class="alert alert-dismissable alert-danger comment_error"><button type="button" class="close" data-dismiss="alert">×</button>コメントを入力してください。</div>');
		clicked_dom.parent("div").addClass('has-error');
		return;
	}
	$.ajax({
		type: 'post',
		url: '/actions/'+action_id+'/users/'+clicked_dom.data('user_id')+'/comments/'+comment+'/add_comment',
	}).done(function(comment){
		var action = $('.comment-for-action[data-action_id="'+action_id+'"]');
		$(action).append(comment);
		comment_field.val("");
		clicked_dom.parent("div").removeClass('has-error');
		$('hr[data-action_id="'+action_id+'"]').css('display','block');
	}).fail(function(){
		clicked_dom.parent("div").addClass('has-error');
		clicked_dom.after('<div class="alert alert-dismissable alert-danger comment_error"><button type="button" class="close" data-dismiss="alert">×</button>通信エラー！もう少し時間をおいてお試しください。</div>');
	});
});

//すごい！がホバーされた時、ajaxでだれがすごい！したかしらべる
$(document).on('mouseenter','.well .badge',function(){
	var clicked_dom = $(this);
	clicked_dom.stop(true, false).before('<div id="greats_mate_list" class="panel"><i class="fa fa-spinner fa-spin" style="font-size:25px;"></i></div>');
	$('#greats_mate_list').css("left",(clicked_dom.position().left + 8));
	$('#greats_mate_list').css("top",(clicked_dom.position().top+30));
	$.ajax({
		type: 'get',
		url: '/greats/'+clicked_dom.parent().data('action_id'),
	}).done(function(mate_list){
		$("div#greats_mate_list").children().remove();
		$('#greats_mate_list').prepend(mate_list);
		$('#greats_mate_list').css("left","0");
		$('#greats_mate_list').css("left",clicked_dom.position().left - $('#greats_mate_list').width() + 31);
	});
}).on('mouseleave','.well .badge',function(){
	$("div#greats_mate_list").stop(true, false).remove();
}).on('click touchstart','.well .badge',function(){
	var action_id = $(this).parent().data('action_id');
	if(!$(this).data("toggled") || $(this).data("toggled") == "off"){
		$.ajax({
			type: 'get',
			url: '/greats/'+action_id,
		}).done(function(mate_list){
			$('.well[data-action_id="'+action_id+'"] .great').after("<div class='greats_mate_list'>"+mate_list+"が褒めています.</div>");
		});
		$(this).data('toggled', 'on');
	}else{
		$('.well[data-action_id="'+action_id+'"] .greats_mate_list').remove();
		$(this).data('toggled', 'off');
	}
});