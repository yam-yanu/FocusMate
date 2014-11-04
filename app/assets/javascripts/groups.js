$(document).on("click",".join_group",function(){
	$(this).css("display","none");
	$(this).prevAll(".shortcut").css("height","100%");
	$(this).next("div").animate({display:'block',opacity:'1'},500);
	$(this).next("div").children("input").focus();
});
$(document).on("click",".check_pass_btn",function(){
	if($(this).prev("input").val() == ""){
		alert("合言葉を入力してください。");
		return;
	}
	$.ajax({
		type: 'post',
		url: "/change_group",
		data: {password: $(this).prev("input").val(),
				group_id: $(this).prev("input").data("group_id")},
	}).done(function(data){
	}).fail(function(){
		alert("通信に失敗しました。\nもう少し時間をおいて試してみてください。");
	});
});
$(document).on("click","#group_modal .close",function(){
	$.ajax({
		type: 'post',
		url: "/change_group",
	}).done(function(){
	}).fail(function(){
		alert("通信に失敗しました。\nもう少し時間をおいて試してみてください。");
	});
});

//グループを作るときにフォームに空欄がないかチェックする
$(document).on("submit","#make_groupModal form",function(){
	var returnValue = true;
	$(this).find("input,textarea").each(function(){
		if($(this).val() == ""){
			alert("入力していない項目があります。");
			returnValue = false;
			return false;
		}
	});
	return returnValue;
});

//お誘いメールを送信
$(document).on("click",".invite_mail_btn",function(){
	var invite_form = $(this).parents("#invite_form");
	if (invite_form.find("input[name='to_address']").val() == ""){
		alert("宛先を入力してください。");
		return;
	}
	$.ajax({
		type: 'get',
		url: "/send_mail",
		data: {to_address: invite_form.find("input[name='to_address']").val(),
				subject: invite_form.find("input[name='subject']").val(),
				body: invite_form.find("textarea[name='body']").val() +"\n"+ invite_form.find("input[name='invite_address']").val()},
	}).done(function(){
		alert("メールの送信が完了しました。");
	}).fail(function(){
		alert("メールの送信に失敗しました。\n通信環境が悪い、宛先が間違っているなどの原因が考えられます。");
	});
	$('#invite_modal').modal('hide');
});

// //別のグループの行動を見る
// $(document).on("click",".group_show_btn",function(){
// 	var display_space = $(this).closest(".one_group");
// 	console.log($(this).prev(".shortcut"));
// 	$(this).prev(".shortcut").removeClass("shortcut");
// 	$(this).css("display","none");
// 	$.ajax({
// 		type: 'get',
// 		url: '/group_show',
// 		data: {group_id: $(this).data("group"),
// 				act_time: $(this).data("act_time")},
// 	}).done(function(actions){
// 		display_space.after(actions);
// 	}).fail(function(){
// 	});
// });