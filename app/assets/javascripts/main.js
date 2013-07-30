$(document).ready(function(){ 
	form_focus_handler();
	date_box_handler();
	$(".multi_select_box").multiselect();

	$('#iframe_popup_dialog').on('hidden', function () {
	    fn_popup_closed_events();
	});

});


// Ajax API call initialization with callback function
// initialize_api_call({"url": "/index", "type": "POST", "params": {"title" : "nature"}}, "callback_function", {"id" : 1});
// function callback_function(response, callback_params, api_params){}
// Created At : 11-04-13, Modified At :
function initialize_api_call(api_params, callback, callback_params){
	if(!api_params["params"]) api_params["params"] = {};
	if(!callback_params) callback_params = {};

	$.ajax({
		  url : api_params["url"], type : api_params["type"], data : api_params["params"],
		  success : function(response)
		  {		  	
		  	if(callback && callback != ""){
			  	window[callback](response, callback_params, api_params);
			}
		  	
		  },
		  error : function()
		  {
		  	
		  }
	});
}


function form_focus_handler(){
	$.each(tab_field_forms, function(key, form){
		$.each(form, function(index, field){
			$(document).on('keydown','#' + field, function(e) {
				var keyCode = e.keyCode || e.which;
	            if(keyCode == 13)
	            {
	            	e.preventDefault();
	            	var form_id = $(this).closest('form').attr('id');
	                var field_index = tab_field_forms[form_id].indexOf($(this).attr('id'));
	                console.log(field_index);
	                if (field_index < form.length - 1)
	                {	                	
	                	$("#" + tab_field_forms[form_id][field_index + 1]).focus();
	                }
	                else
	                    $("#" + form_id).submit();
	            }
      		});
      		    
		});
	});
}


function date_box_handler(){
	$.each(date_box_fields, function(key, field){
		$("#"+field["name"]).datepicker({
			changeMonth: true,
			changeYear: true
		});
		$("#"+field["name"]).datepicker("option","dateFormat","yy-mm-dd");
		$("#"+field["name"]).datepicker("setDate", new Date(field["value"]));

		// $("#"+field).datetimepicker({
		// 	pickTime: false 
		// }).on( "changeDate", function(ev) {
		// 	$(this).datetimepicker("hide");
		// });
	});
}


function callback_function(response, callback_params, api_params){
	$("#item_data").html(response);
}


function show_box(id) {
   $('.widget-box.visible').removeClass('visible');
   $('#'+id).addClass('visible');
}


function show_iframe_popup(iframe_url, params){
	$('#iframe_popup_dialog').on('show', function (){ 		 
		$('#iframe_popup_header').html(params["header"]);		
     	$('iframe').attr("src", iframe_url);
    });    
    $('#iframe_popup_dialog').modal({show:true});
}
