(function(e){var t=function(){var t=65,i='<div class="colorpicker"><div class="colorpicker_color"><div><div></div></div></div><div class="colorpicker_hue"><div></div></div><div class="colorpicker_new_color"></div><div class="colorpicker_current_color"></div><div class="colorpicker_hex"><input type="text" maxlength="6" size="6" /></div><div class="colorpicker_rgb_r colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_rgb_g colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_rgb_b colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_hsb_h colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_hsb_s colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_hsb_b colorpicker_field"><input type="text" maxlength="3" size="3" /><span></span></div><div class="colorpicker_submit"></div></div>',n={eventName:"click",onShow:function(){},onBeforeShow:function(){},onHide:function(){},onChange:function(){},onSubmit:function(){},color:"ff0000",livePreview:!0,flat:!1},s=function(t,i){var n=j(t);e(i).data("colorpicker").fields.eq(1).val(n.r).end().eq(2).val(n.g).end().eq(3).val(n.b).end()},a=function(t,i){e(i).data("colorpicker").fields.eq(4).val(t.h).end().eq(5).val(t.s).end().eq(6).val(t.b).end()},r=function(t,i){e(i).data("colorpicker").fields.eq(0).val(R(t)).end()},o=function(t,i){e(i).data("colorpicker").selector.css("backgroundColor","#"+R({h:t.h,s:100,b:100})),e(i).data("colorpicker").selectorIndic.css({left:parseInt(150*t.s/100,10),top:parseInt(150*(100-t.b)/100,10)})},l=function(t,i){e(i).data("colorpicker").hue.css("top",parseInt(150-150*t.h/360,10))},u=function(t,i){e(i).data("colorpicker").currentColor.css("backgroundColor","#"+R(t))},c=function(t,i){e(i).data("colorpicker").newColor.css("backgroundColor","#"+R(t))},h=function(i){var n=i.charCode||i.keyCode||-1;if(n>t&&90>=n||32==n)return!1;var s=e(this).parent().parent();s.data("colorpicker").livePreview===!0&&d.apply(this)},d=function(t){var i,n=e(this).parent().parent();n.data("colorpicker").color=i=this.parentNode.className.indexOf("_hex")>0?H(M(this.value)):this.parentNode.className.indexOf("_hsb")>0?N({h:parseInt(n.data("colorpicker").fields.eq(4).val(),10),s:parseInt(n.data("colorpicker").fields.eq(5).val(),10),b:parseInt(n.data("colorpicker").fields.eq(6).val(),10)}):L(P({r:parseInt(n.data("colorpicker").fields.eq(1).val(),10),g:parseInt(n.data("colorpicker").fields.eq(2).val(),10),b:parseInt(n.data("colorpicker").fields.eq(3).val(),10)})),t&&(s(i,n.get(0)),r(i,n.get(0)),a(i,n.get(0))),o(i,n.get(0)),l(i,n.get(0)),c(i,n.get(0)),n.data("colorpicker").onChange.apply(n,[i,R(i),j(i)])},p=function(){var t=e(this).parent().parent();t.data("colorpicker").fields.parent().removeClass("colorpicker_focus")},f=function(){t=this.parentNode.className.indexOf("_hex")>0?70:65,e(this).parent().parent().data("colorpicker").fields.parent().removeClass("colorpicker_focus"),e(this).parent().addClass("colorpicker_focus")},g=function(t){var i=e(this).parent().find("input").focus(),n={el:e(this).parent().addClass("colorpicker_slider"),max:this.parentNode.className.indexOf("_hsb_h")>0?360:this.parentNode.className.indexOf("_hsb")>0?100:255,y:t.pageY,field:i,val:parseInt(i.val(),10),preview:e(this).parent().parent().data("colorpicker").livePreview};e(document).bind("mouseup",n,v),e(document).bind("mousemove",n,m)},m=function(e){return e.data.field.val(Math.max(0,Math.min(e.data.max,parseInt(e.data.val+e.pageY-e.data.y,10)))),e.data.preview&&d.apply(e.data.field.get(0),[!0]),!1},v=function(t){return d.apply(t.data.field.get(0),[!0]),t.data.el.removeClass("colorpicker_slider").find("input").focus(),e(document).unbind("mouseup",v),e(document).unbind("mousemove",m),!1},b=function(){var t={cal:e(this).parent(),y:e(this).offset().top};t.preview=t.cal.data("colorpicker").livePreview,e(document).bind("mouseup",t,w),e(document).bind("mousemove",t,y)},y=function(e){return d.apply(e.data.cal.data("colorpicker").fields.eq(4).val(parseInt(360*(150-Math.max(0,Math.min(150,e.pageY-e.data.y)))/150,10)).get(0),[e.data.preview]),!1},w=function(t){return s(t.data.cal.data("colorpicker").color,t.data.cal.get(0)),r(t.data.cal.data("colorpicker").color,t.data.cal.get(0)),e(document).unbind("mouseup",w),e(document).unbind("mousemove",y),!1},C=function(){var t={cal:e(this).parent(),pos:e(this).offset()};t.preview=t.cal.data("colorpicker").livePreview,e(document).bind("mouseup",t,_),e(document).bind("mousemove",t,x)},x=function(e){return d.apply(e.data.cal.data("colorpicker").fields.eq(6).val(parseInt(100*(150-Math.max(0,Math.min(150,e.pageY-e.data.pos.top)))/150,10)).end().eq(5).val(parseInt(100*Math.max(0,Math.min(150,e.pageX-e.data.pos.left))/150,10)).get(0),[e.data.preview]),!1},_=function(t){return s(t.data.cal.data("colorpicker").color,t.data.cal.get(0)),r(t.data.cal.data("colorpicker").color,t.data.cal.get(0)),e(document).unbind("mouseup",_),e(document).unbind("mousemove",x),!1},S=function(){e(this).addClass("colorpicker_focus")},k=function(){e(this).removeClass("colorpicker_focus")},D=function(){var t=e(this).parent(),i=t.data("colorpicker").color;t.data("colorpicker").origColor=i,u(i,t.get(0)),t.data("colorpicker").onSubmit(i,R(i),j(i),t.data("colorpicker").el)},T=function(){var t=e("#"+e(this).data("colorpickerId"));t.data("colorpicker").onBeforeShow.apply(this,[t.get(0)]);var i=e(this).offset(),n=A(),s=i.top+this.offsetHeight,a=i.left;return s+176>n.t+n.h&&(s-=this.offsetHeight+176),a+356>n.l+n.w&&(a-=356),t.css({left:a+"px",top:s+"px"}),t.data("colorpicker").onShow.apply(this,[t.get(0)])!=0&&t.show(),e(document).bind("mousedown",{cal:t},E),!1},E=function(t){I(t.data.cal.get(0),t.target,t.data.cal.get(0))||(t.data.cal.data("colorpicker").onHide.apply(this,[t.data.cal.get(0)])!=0&&t.data.cal.hide(),e(document).unbind("mousedown",E))},I=function(e,t,i){if(e==t)return!0;if(e.contains)return e.contains(t);if(e.compareDocumentPosition)return!!(e.compareDocumentPosition(t)&16);for(var n=t.parentNode;n&&n!=i;){if(n==e)return!0;n=n.parentNode}return!1},A=function(){var e=document.compatMode=="CSS1Compat";return{l:window.pageXOffset||(e?document.documentElement.scrollLeft:document.body.scrollLeft),t:window.pageYOffset||(e?document.documentElement.scrollTop:document.body.scrollTop),w:window.innerWidth||(e?document.documentElement.clientWidth:document.body.clientWidth),h:window.innerHeight||(e?document.documentElement.clientHeight:document.body.clientHeight)}},N=function(e){return{h:Math.min(360,Math.max(0,e.h)),s:Math.min(100,Math.max(0,e.s)),b:Math.min(100,Math.max(0,e.b))}},P=function(e){return{r:Math.min(255,Math.max(0,e.r)),g:Math.min(255,Math.max(0,e.g)),b:Math.min(255,Math.max(0,e.b))}},M=function(e){var t=6-e.length;if(t>0){for(var i=[],n=0;t>n;n++)i.push("0");i.push(e),e=i.join("")}return e},F=function(e){var e=parseInt(e.indexOf("#")>-1?e.substring(1):e,16);return{r:e>>16,g:(65280&e)>>8,b:255&e}},H=function(e){return L(F(e))},L=function(e){var t={h:0,s:0,b:0},i=Math.min(e.r,e.g,e.b),n=Math.max(e.r,e.g,e.b),s=n-i;return t.b=n,t.s=0!=n?255*s/n:0,t.h=t.s!=0?e.r==n?(e.g-e.b)/s:e.g==n?2+(e.b-e.r)/s:4+(e.r-e.g)/s:-1,t.h*=60,t.h<0&&(t.h+=360),t.s*=100/255,t.b*=100/255,t},j=function(e){var t={},i=Math.round(e.h),n=Math.round(e.s*255/100),s=Math.round(e.b*255/100);if(0==n)t.r=t.g=t.b=s;else{var a=s,r=(255-n)*s/255,o=(a-r)*(i%60)/60;360==i&&(i=0),60>i?(t.r=a,t.b=r,t.g=r+o):120>i?(t.g=a,t.b=r,t.r=a-o):180>i?(t.g=a,t.r=r,t.b=r+o):240>i?(t.b=a,t.r=r,t.g=a-o):300>i?(t.b=a,t.g=r,t.r=r+o):360>i?(t.r=a,t.g=r,t.b=a-o):(t.r=0,t.g=0,t.b=0)}return{r:Math.round(t.r),g:Math.round(t.g),b:Math.round(t.b)}},O=function(t){var i=[t.r.toString(16),t.g.toString(16),t.b.toString(16)];return e.each(i,function(e,t){t.length==1&&(i[e]="0"+t)}),i.join("")},R=function(e){return O(j(e))},$=function(){var t=e(this).parent(),i=t.data("colorpicker").origColor;t.data("colorpicker").color=i,s(i,t.get(0)),r(i,t.get(0)),a(i,t.get(0)),o(i,t.get(0)),l(i,t.get(0)),c(i,t.get(0))};return{init:function(t){if(t=e.extend({},n,t||{}),typeof t.color=="string")t.color=H(t.color);else if(t.color.r!=void 0&&t.color.g!=void 0&&t.color.b!=void 0)t.color=L(t.color);else{if(t.color.h==void 0||t.color.s==void 0||t.color.b==void 0)return this;t.color=N(t.color)}return this.each(function(){if(!e(this).data("colorpickerId")){var n=e.extend({},t);n.origColor=t.color;var m="collorpicker_"+parseInt(Math.random()*1e3);e(this).data("colorpickerId",m);var v=e(i).attr("id",m);n.flat?v.appendTo(this).show():v.appendTo(document.body),n.fields=v.find("input").bind("keyup",h).bind("change",d).bind("blur",p).bind("focus",f),v.find("span").bind("mousedown",g).end().find(">div.colorpicker_current_color").bind("click",$),n.selector=v.find("div.colorpicker_color").bind("mousedown",C),n.selectorIndic=n.selector.find("div div"),n.el=this,n.hue=v.find("div.colorpicker_hue div"),v.find("div.colorpicker_hue").bind("mousedown",b),n.newColor=v.find("div.colorpicker_new_color"),n.currentColor=v.find("div.colorpicker_current_color"),v.data("colorpicker",n),v.find("div.colorpicker_submit").bind("mouseenter",S).bind("mouseleave",k).bind("click",D),s(n.color,v.get(0)),a(n.color,v.get(0)),r(n.color,v.get(0)),l(n.color,v.get(0)),o(n.color,v.get(0)),u(n.color,v.get(0)),c(n.color,v.get(0)),n.flat?v.css({position:"relative",display:"block"}):e(this).bind(n.eventName,T)}})},showPicker:function(){return this.each(function(){e(this).data("colorpickerId")&&T.apply(this)})},hidePicker:function(){return this.each(function(){e(this).data("colorpickerId")&&e("#"+e(this).data("colorpickerId")).hide()})},setColor:function(t){if("string"==typeof t)t=H(t);else if(t.r!=void 0&&t.g!=void 0&&t.b!=void 0)t=L(t);else{if(t.h==void 0||t.s==void 0||t.b==void 0)return this;t=N(t)}return this.each(function(){if(e(this).data("colorpickerId")){var i=e("#"+e(this).data("colorpickerId"));i.data("colorpicker").color=t,i.data("colorpicker").origColor=t,s(t,i.get(0)),a(t,i.get(0)),r(t,i.get(0)),l(t,i.get(0)),o(t,i.get(0)),u(t,i.get(0)),c(t,i.get(0))}})}}}();e.fn.extend({ColorPicker:t.init,ColorPickerHide:t.hidePicker,ColorPickerShow:t.showPicker,ColorPickerSetColor:t.setColor})})(jQuery);