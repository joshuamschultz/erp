function initialize_api_call(e,t,i){e.params||(e.params={}),i||(i={}),$.ajax({url:e.url,type:e.type,data:e.params,dataType:e.data_type,success:function(n){t&&""!=t&&window[t](n,i,e)},error:function(){}})}function form_focus_handler(){$.each(tab_field_forms,function(e,t){$.each(t,function(e,i){$(document).on("keydown","#"+i,function(e){var i=e.keyCode||e.which;if(13==i){e.preventDefault();var n=$(this).closest("form").attr("id"),s=tab_field_forms[n].indexOf($(this).attr("id"));console.log(s),s<t.length-1?$("#"+tab_field_forms[n][s+1]).focus():$("#"+n).submit()}})})})}function date_box_handler(){$.each(date_box_fields,function(e,t){$("#"+t.name).datepicker({changeMonth:!0,changeYear:!0,onSelect:function(){$(this).focus()}}),$("#"+t.name).datepicker("option","dateFormat","yy-mm-dd"),$("#"+t.name).datepicker("setDate",new Date(t.value))})}function callback_function(e){$("#item_data").html(e)}function show_box(e){$(".widget-box.visible").removeClass("visible"),$("#"+e).addClass("visible")}function show_iframe_popup(e,t){$("#iframe_popup_dialog").on("show",function(){$("#iframe_popup_header").html(t.header),$("iframe").attr("src",e)}),$("#iframe_popup_dialog").modal({show:!0})}$(document).ready(function(){form_focus_handler(),date_box_handler(),$(".multi_select_box").multiselect().multiselectfilter(),$("#iframe_popup_dialog").on("hidden",function(){fn_popup_closed_events()})});