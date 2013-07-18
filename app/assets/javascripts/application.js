// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ./theme_js/less.min.js
//= require ./theme_js/jquery.min.js
//= require ./theme_js/modernizr.js
//= require ./theme_js/bootstrap.min.js
//= require ./theme_js/jquery.slimscroll.min.js
//= require ./theme_js/common.js
//= require ./theme_js/holder.js
//= require ./theme_js/jquery.uniform.min.js
//= require ./theme_js/jquery.dataTables.min.js
//= require ./theme_js/DT_bootstrap.js

var tab_field_forms = {};

$(document).ready(function(){ 
	form_focus_handler();

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
