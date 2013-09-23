$(document).ready(function(){ 
	form_focus_handler();
	date_box_handler();
	$(".multi_select_box").multiselect().multiselectfilter();

	$('#iframe_popup_dialog').on('hidden', function () {
	    fn_popup_closed_events();
	});

	setTimeout(click_upload_close, 2000);
});


// Ajax API call initialization with callback function
// initialize_api_call({"url": "/index", "type": "POST", "params": {"title" : "nature"}}, "callback_function", {"id" : 1});
// function callback_function(response, callback_params, api_params){}
// Created At : 11-04-13, Modified At :
function initialize_api_call(api_params, callback, callback_params){
	if(!api_params["params"]) api_params["params"] = {};
	if(!callback_params) callback_params = {};

	$.ajax({
		  url : api_params["url"], type : api_params["type"], data : api_params["params"], dataType: api_params["data_type"], 
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
			changeYear: true,
			onSelect: function(dateText) {
			   	$(this).focus();
			}
		});
		$("#"+field["name"]).datepicker("option","dateFormat","yy-mm-dd");
		$("#"+field["name"]).datepicker("setDate", new Date(field["value"]));

		// $("#"+field).datetimepicker({
		// 	pickTime: false 
		// });

		// $("#"+field["name"]).on("change", function(ev) {
		// 	console.log(11);
		// 	$(this).focus();
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

function click_upload_close(){
    $(".close").click();
}

function table_row_next_focus(e, form_name, current_element, next_element, next_row){
    var keyCode = e.keyCode || e.which;
    var found_next_element = null;
    if(keyCode == 13){
        e.preventDefault();
        if(next_row){
            found_next_element = current_element.closest("tr").next();
            found_next_element = next_visible_element(found_next_element);
            found_next_element = found_next_element.find(next_element);
        }
        else
            found_next_element = current_element.closest("tr").find(next_element);

        var next_index = found_next_element.index();

        if(next_index != -1){
            found_next_element.focus();
            return false;     
        }
        else{
            $(form_name).submit();
            return true;
        }
    }
    else
    	return true;
}

function next_visible_element(element){
    if(element.attr("type") == "hidden"){
        element = element.next();
        element = next_visible_element(element);
    }
    
    return element;
}
