/**
 * SASAPI Javascript Companion Library
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

if (typeof sekati == "undefined") var sekati = new Object();

sekati.mw = {
	// ported from osxmousewheel (c) Ali Rantakari http://hasseg.org/blog
	_container: null,
	
	// the id/name of your flash apps HTML DOM elementÊ
	_flashMovieId: null,
	
	// the id/name of the flash elements surrounding div element	
	_flashContainerId: null,
	
	thisMovie: function (movieName) {
    	if (navigator.appName.indexOf("Microsoft") != -1) {
        	return window[movieName];
    	} else {
    	    return document[movieName];
    	}
	},

	init: function (movieId, containerId) {
		
		sekati.mw._flashMovieId = movieId;
		sekati.mw._flashContainerId = containerId;
	
		// initialize mouse wheel capturing:
		if (navigator.userAgent.indexOf('Mac') != -1) {
			
			sekati.mw._container = document.getElementById(_flashContainerId);
			if (sekati.mw._container != null) {
				if (sekati.mw._container.addEventListener) {
					// Firefox
					sekati.mw._container.addEventListener('DOMMouseScroll', sekati.mw.onWheelHandler, false); 
				}
				// Safari
				sekati.mw._container.onmousewheel = sekati.mw.onWheelHandler; 
			} else {
				alert("osxmousewheel: can not find flash container div element");
			}
		}
	},	
	
	// mouse wheel event handler
	onWheelHandler: function (event){
		
		var delta = 0;
		if (!event) event = window.event;
		if (event.wheelDelta) {
			// Safari
			delta = event.wheelDelta/120;
			if (window.opera) delta = -delta;
		} else if (event.detail) {
			// Firefox
			delta = -event.detail*3;
		}
		
		// keep delta in flashplayer range
		if (delta > 0) { 
			delta = 3;
		} else { 
			delta = -3;
		}
		
		alert("delta: "+delta);
		
		if (delta) {
			// handle mouse events here:
			
			var thisMouse;
			if ((navigator.userAgent.indexOf('Firefox') != -1) || (navigator.userAgent.indexOf('Camino') != -1)) thisMouse = {x:event.layerX, y:event.layerY};
			else if (navigator.userAgent.indexOf('Safari') != -1) thisMouse = {x:event.offsetX, y:event.offsetY};
			else if (navigator.userAgent.indexOf('Opera') != -1) thisMouse = {x:event.offsetX, y:event.offsetY};
			else thisMouse = {x:event.offsetX, y:event.offsetY};
			
			if (sekati.mw.thisMovie(_flashMovieId).dispatchExternalMouseWheelEvent) sekati.mw.thisMovie(_flashMovieId).dispatchExternalMouseWheelEvent(delta, thisMouse.x, thisMouse.y);
			else alert("osxmousewheel: ExternalInferface function dispatchExternalMouseWheelEvent not found");
			
		};
		// Prevent default actions caused by mouse wheel.
		if (event.preventDefault) event.preventDefault();
		event.returnValue = false;
	}


}

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