/**
 * SASAPI Javascript Companion Library
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

if (typeof sekati == "undefined") var sekati = new Object();

/////////////////////////////////////////////////////////////////////////////////
// deeplinking

sekati.swflink = {
	
	_location: document.location.href.split("#")[0],

	_title: document.title,
	
	set: function(t, a) {
		if (t) document.title = sekati.swflink._title + " : " + t;
		if (a) document.location.href = sekati.swflink._location + "#" + a;
		//document.location = sekati.swflink._location + '#fuck';
	},
	
	get: function() {
		var hash = document.location.href.split("#")[1];
		if (hash) return hash;	
	},
	
	// call actionscript function: document.movieID.myFlashFunction( [argumentArray] );
	asCall: function (id, fn, argArr) {
		document[id][fn](argArr);
	}
};

/////////////////////////////////////////////////////////////////////////////////
// interface

sekati.ui = {
	
	// Toggle usage: onclick="sekati.ui.toggle(this,'targetID','show','hide')"
	toggle: function (link, id) {
		var box=document.getElementById(id);
		if (box) {
			if (box.style.display) { box.style.display=""; } else { box.style.display="none"; }
		}
	},
	
	// ifocus usage: <input type="text" name="hw" value="hello world" onfocus="sekati.ui.focus(this)" onblur="sekati.ui.blur(this)" />
	focus: function (inp) {  
		var defval;  
		if (inp) { 
			if ((defval=inp.getAttribute("defval")) && inp.value==defval) inp.value="";  
				else if (!defval) { inp.setAttribute("defval",inp.value); inp.value=""; } 
			} 
	},
	
	blur: function(inp) { 
		var defval; 
		if (inp && inp.value=="" && (defval=inp.getAttribute("defval"))) inp.value=defval; 
	},
	
	// confirmbox usage: <a href="#" onclick="sekati.ui.confirmbox('Are you sure?','yes.html')">delete</a>
	confirmbox: function (q, a) { 
		if (confirm(q)) window.location = a; 
	},	
	
	// pop usage: <a href="info.html" target="info" onclick="sekati.ui.pop(this.href, this.target, 500, 400);return false;">info</a>		
	pop: function (url, win, w, h, x, y, toolbar, location, status, menubar, scrollbars, resizeable) {
		var sx = (x == "center") ? (screen.availWidth - width) / 2 : x;
		var sy = (y == "center") ? (screen.availHeight - height) / 2 : y;
		var ww = (w == "fullscreen") ? screen.availWidth : w;
		var wh = (h == "fullscreen") ? screen.availHeight : h;
		var tb = (toolbar == true) ? "yes" : "no";
		var lc = (location == true) ? "yes" : "no";
		var st = (status == true) ? "yes" : "no";
		var mb = (menubar == true) ? "yes" : "no";
		var sc = (scrollbars == true) ? "auto" : "no";
		var re = (resizeable == true) ? "yes" : "no";
		var properties = "toolbar=" + tb + ",location=" + lc + ",directories=no,status=" + st + ",menubar=" + mb + ",scrollbars=" + sc + ",resizable=" + re + ",width=" + ww + ",height=" + wh + ",screenX=" + sx + ",screenY=" + sy;
		var pop = window.open(url, win, properties);
		pop.focus();
	}	
};

/////////////////////////////////////////////////////////////////////////////////
// tools

sekati.util = {

	browserSize: function(){
		if (self.innerWidth){
			return {w: self.innerWidth, h: self.innerHeight};
		}else if (document.documentElement && document.documentElement.clientWidth){
			return {w: document.documentElement.clientWidth, h: document.documentElement.clientHeight};
		}else if (document.body){
			return {w: document.body.clientWidth, h: document.body.clientHeight};
		}
		
		return false;
	},
	
	// helper functions tied to swfIN (http://swfin.nectere.ca)
	browserW: function() {
		return sekati.util.browserSize().w
	},
	
	browserH: function () {
		return sekati.util.browserSize().h
	},
	
	// get entire url	
	ref: function() {
		return document.location.href;
	}
	
};

/////////////////////////////////////////////////////////////////////////////////
// swfIN mac mousewheel support - based on osxmousewheel & swfmacmousewheel.
// Usage: var mousewheel = new MouseWheel(swfIN_instance);

function MouseWheel (swfIN) {
 	this.so = swfIN;
 	var isMac = navigator.appVersion.toLowerCase().indexOf( "mac" ) != -1;
 	if(isMac) this.init();
 } 
 
MouseWheel.prototype = {	
	init: function() {
		MouseWheel.instance = this;	
		if (window.addEventListener) window.addEventListener('DOMMouseScroll', MouseWheel.instance.wheel, false);
		window.onmousewheel = document.onmousewheel = MouseWheel.instance.wheel;
	},
	handle: function(delta){
		document[this.so.getEmbedStringID()].externalMouseEvent(delta);
	},
	wheel: function(event){
		var delta = 0;
		if (event.wheelDelta) {
			// IE, Opera
			delta = event.wheelDelta/120;
			if (window.opera) delta = -delta;
		} else if (event.detail) {
			// Mozilla
			delta = -event.detail/3;
		}		
		// safari
       	if(/AppleWebKit/.test(navigator.userAgent)) delta /= 3;
		// constrain
		if (delta > 3) { delta = 3; } else if (delta < -3) { delta = -3; }		
		//
		if (delta) MouseWheel.instance.handle(delta);
		if (event.preventDefault) event.preventDefault();
		event.returnValue = false;
	}
};