/**
 * com.sekati.draw.Graphic
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
import com.sekati.core.KeyFactory;
/**
 * {@code Usage:
 * var gr:Graphics = new Graphics(2);
 * gr.setColor("0xff0000");
 * gr.setThick(3);
 * gr.drawLine(0,0,100,100);
 * gr.setFill("0x0000ff");
 * // draw a rect at (20,20, 200 wide, 100 high 
 * // and fill color blue
 * gr.fillRect(20,20,200,50);
 * gr.drawCircle(50,30,55);
 * // change line color to green
 * gr.setColor("0x00ff00");
 * gr.drawLine(100,100,200,200);
 * }
 */
class com.sekati.draw.Graphic extends MovieClip {
	var _mc;
	var color:String;
	var fill:String;
	var thick:Number;
	// constructor
	public function Graphics (target:MovieClip) {
		_mc = target.createEmptyMovieClip ("graphic_"+KeyFactory.getNextName(),target.getNextHighestDepth());
		KeyFactory.inject(_mc);
		// set defaults
		color = "0x000000";
		thick = 1;
		fill = "0x666666";
	}
	// setters
	function setColor (_color:String) {
		color = _color;
	}
	// set thickness
	function setThick (_thick:Number) {
		thick = _thick;
	}
	// set fill
	function setFill (_fill:String) {
		fill = _fill;
	}
	//change depth
	function changeDepth (_depth:Number) {
		_mc.swapDepths (_depth);
	}
	//
	//drawing functions
	function drawLine (x1:Number, y1:Number, x2:Number, y2:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (x1,y1);
		_mc.lineTo (x2,y2);
	}
	function drawRect (x1:Number, y1:Number, width:Number, height:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (x1,y1);
		_mc.lineTo (x1 + width,y1);
		_mc.lineTo (x1 + width,y1 + height);
		_mc.lineTo (x1,y1 + height);
		_mc.lineTo (x1,y1);
	}
	// fillRect
	function fillRect (x1:Number, y1:Number, width:Number, height:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (x1,y1);
		_mc.beginFill (fill);
		_mc.lineTo (x1 + width,y1);
		_mc.lineTo (x1 + width,y1 + height);
		_mc.lineTo (x1,y1 + height);
		_mc.lineTo (x1,y1);
		_mc.endFill ();
	}
	//------DRAW CURVE-------//

	function drawCurve (startX:Number, startY:Number, curveControlX:Number, curveControlY:Number, endX:Number, endY:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (startX,startY);
		_mc.curveTo (curveControlX,curveControlY,endX,endY);
	}
	// draw Oval
	function drawOval (x:Number, y:Number, width:Number, height:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (x,y + height / 2);
		_mc.curveTo (x,y,x + width / 2,y);
		_mc.curveTo (x + width,y,x + width,y + height / 2);
		_mc.curveTo (x + width,y + height,x + width / 2,y + height);
		_mc.curveTo (x,y + height,x,y + height / 2);
	}
	// draw Oval - improved!
	function drawOval2 (x:Number,y:Number,width:Number,height:Number) {
		var j = width * 0.70711;
		var n = height * 0.70711;
		var i = j - (height - n) * width / height;
		var m = n - (width - j) * height / width;
		_mc.lineStyle(thick, color);
		_mc.moveTo(x + width, y);
		_mc.curveTo(x + width, y - m, x + j, y - n);
		_mc.curveTo(x + i, y - height, x, y - height);
		_mc.curveTo(x - i, y - height, x - j, y - n);
		_mc.curveTo(x - width, y - m, x - width, y);
		_mc.curveTo(x - width, y + m, x - j, y + n);
		_mc.curveTo(x - i, y + height, x, y + height);
		_mc.curveTo(x + i, y + height, x + j, y + n);
		_mc.curveTo(x + width, y + m, x + width, y);
	}
	// ---------FILL OVAL------------//
	function fillOval (x:Number, y:Number, width:Number, height:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (x,y + height / 2);
		_mc.beginFill (fill);
		_mc.curveTo (x,y,x + width / 2,y);
		_mc.curveTo (x + width,y,x + width,y + height / 2);
		_mc.curveTo (x + width,y + height,x + width / 2,y + height);
		_mc.curveTo (x,y + height,x,y + height / 2);
		_mc.endFill ();
	}
	//---------DRAW CIRCLE-----------//
	//if argument styleMaker == 22.5 you get a full circle 
	//  66 makes a star like figure
	// usage :  drawCircle(radius,x,y,22.5)
	function drawCircle (r:Number, x:Number, y:Number) {
		var styleMaker:Number = 22.5;
		_mc.moveTo (x + r,y);
		_mc.lineStyle (thick,color);
		var style:Number = Math.tan (styleMaker * Math.PI / 180);
		for (var angle:Number = 45; angle <= 360; angle += 45) {
			var endX:Number = r * Math.cos (angle * Math.PI / 180);
			var endY:Number = r * Math.sin (angle * Math.PI / 180);
			var cX:Number = endX + r * style * Math.cos ((angle - 90) * Math.PI / 180);
			var cY:Number = endY + r * style * Math.sin ((angle - 90) * Math.PI / 180);
			_mc.curveTo (cX + x,cY + y,endX + x,endY + y);
		}
	}
	// ---------DRAW FILLED circle, -----------//
	//if argument styleMaker == 22.5 you get a full circle 
	//    66 makes a star like figure
	// usage :  fillCircle(radius,x,y,22.5)
	function fillCircle (r:Number, x:Number, y:Number) {
		var styleMaker:Number = 22.5;
		_mc.moveTo (x + r,y);
		_mc.lineStyle (thick,color);
		_mc.beginFill (fill);
		var style:Number = Math.tan (styleMaker * Math.PI / 180);
		for (var angle:Number = 45; angle <= 360; angle += 45) {
			var endX:Number = r * Math.cos (angle * Math.PI / 180);
			var endY:Number = r * Math.sin (angle * Math.PI / 180);
			var cX:Number = endX + r * style * Math.cos ((angle - 90) * Math.PI / 180);
			var cY:Number = endY + r * style * Math.sin ((angle - 90) * Math.PI / 180);
			_mc.curveTo (cX + x,cY + y,endX + x,endY + y);
		}
		_mc.endFill ();
	}
	//----- DRAW helix shape ---//
	//if argument styleMaker == 22.5 you get a full circle 
	//  66 makes a star like figure
	// usage :  drawCircle(radius,x,y,22.5)
	function drawHelix (r:Number, x:Number, y:Number, styleMaker:Number) {
		_mc.moveTo (x + r,y);
		_mc.lineStyle (thick,color);
		var style:Number = Math.tan (styleMaker * Math.PI / 180);
		for (var angle:Number = 45; angle <= 360; angle += 45) {
			var endX:Number = r * Math.cos (angle * Math.PI / 180);
			var endY:Number = r * Math.sin (angle * Math.PI / 180);
			var cX:Number = endX + r * style * Math.cos ((angle - 90) * Math.PI / 180);
			var cY:Number = endY + r * style * Math.sin ((angle - 90) * Math.PI / 180);
			_mc.curveTo (cX + x,cY + y,endX + x,endY + y);
		}
	}
	// ---------DRAW FILLED helix SHAPE, -----------//
	//if argument styleMaker == 22.5 you get a full circle 
	//    66 makes a star like figure
	// usage :  fillCircle(radius,x,y,22.5)
	function fillHelix (r:Number, x:Number, y:Number, styleMaker:Number) {
		_mc.moveTo (x + r,y);
		_mc.lineStyle (thick,color);
		_mc.beginFill (fill);
		var style:Number = Math.tan (styleMaker * Math.PI / 180);
		for (var angle:Number = 45; angle <= 360; angle += 45) {
			var endX:Number = r * Math.cos (angle * Math.PI / 180);
			var endY:Number = r * Math.sin (angle * Math.PI / 180);
			var cX:Number = endX + r * style * Math.cos ((angle - 90) * Math.PI / 180);
			var cY:Number = endY + r * style * Math.sin ((angle - 90) * Math.PI / 180);
			_mc.curveTo (cX + x,cY + y,endX + x,endY + y);
		}
		_mc.endFill ();
	}
	//--------------DRAW GRADIENT SHAPE--------------//
	//this does the same as above only now with a gradient option
	//useage example : 
	//drawGradientShape(140,200,40,22.5,
	//0x0000ff,0x0000ff,100,50,50,50,100,100);
	function drawGradientShape (r:Number, x:Number, y:Number, styleMaker:Number, col1:Number, col2:Number, fa1:Number, fa2:Number, matrixX:Number, matrixY:Number, matrixW:Number, matrixH:Number) {
		_mc.lineStyle (thick,color);
		_mc.moveTo (x + r,y);
		var colors:Array = [col1, col2];
		var alphas:Array = [fa1, fa2];
		var ratios:Array = [7, 0xFF];
		var matrix:Object = {matrixType:"box", x:matrixX, y:matrixY, w:matrixW, h:matrixH, r:(45 / 180) * Math.PI};
		_mc.beginGradientFill ("linear",colors,alphas,ratios,matrix);
		var style:Number = Math.tan (styleMaker * Math.PI / 180);
		for (var angle:Number = 45; angle <= 360; angle += 45) {
			var endX:Number = r * Math.cos (angle * Math.PI / 180);
			var endY:Number = r * Math.sin (angle * Math.PI / 180);
			var cX:Number = endX + r * style * Math.cos ((angle - 90) * Math.PI / 180);
			var cY:Number = endY + r * style * Math.sin ((angle - 90) * Math.PI / 180);
			_mc.curveTo (cX + x,cY + y,endX + x,endY + y);
		}
		_mc.endFill ();
	}
	//
	//-----------GRADIENT RECTANGLE-----------//
	//gradientRect(0,0,200,200,0x0000ff,0x0000aa,100,100,50,50,100,100)
	function gradientRect (x1:Number, y1:Number, width:Number, height:Number, col1:Number, col2:Number, fa1:Number, fa2:Number, matrixX:Number, matrixY:Number, matrixW:Number, matrixH:Number) {
		_mc.lineStyle (thick,color);
		var colors:Array = [col1, col2];
		var alphas:Array = [fa1, fa2];
		var ratios:Array = [7, 0xFF];
		var matrix:Object = {matrixType:"box", x:matrixX, y:matrixY, w:matrixW, h:matrixH, r:(45 / 180) * Math.PI};
		_mc.moveTo (x1,y1);
		_mc.beginGradientFill ("linear",colors,alphas,ratios,matrix);
		_mc.lineTo (x1 + width,y1);
		_mc.lineTo (x1 + width,y1 + height);
		_mc.lineTo (x1,y1 + height);
		_mc.lineTo (x1,y1);
		_mc.endFill ();
	}
	// 
	// ----DRAW HEXAGON ----//
	//
	public function drawHexagon (hexRadius:Number, startX, startY) {
		var sideC:Number = hexRadius;
		var sideA:Number = 0.5 * sideC;
		var sideB:Number = Math.sqrt ((hexRadius * hexRadius) - (0.5 * hexRadius) * (0.5 * hexRadius));
		_mc.lineStyle (thick,color,100);
		_mc.moveTo (startX,startY);
		_mc.lineTo (startX,sideC + startY);
		_mc.lineTo (sideB + startX,startY + sideA + sideC);
		// bottom point
		_mc.lineTo (2 * sideB + startX,startY + sideC);
		_mc.lineTo (2 * sideB + startX,startY);
		_mc.lineTo (sideB + startX,startY - sideA);
		_mc.lineTo (startX,startY);
	}
	//usage would be drawHexagon(sideLength, startX , start Y)
	// 
	// ----fill HEXAGON----//
	//
	public function fillHexagon (hexRadius:Number, startX, startY) {
		var sideC:Number = hexRadius;
		var sideA:Number = 0.5 * sideC;
		var sideB:Number = Math.sqrt ((hexRadius * hexRadius) - (0.5 * hexRadius) * (0.5 * hexRadius));
		_mc.lineStyle (thick,color,100);
		_mc.beginFill (fill);
		_mc.moveTo (startX,startY);
		_mc.lineTo (startX,sideC + startY);
		_mc.lineTo (sideB + startX,startY + sideA + sideC);
		// bottom point
		_mc.lineTo (2 * sideB + startX,startY + sideC);
		_mc.lineTo (2 * sideB + startX,startY);
		_mc.lineTo (sideB + startX,startY - sideA);
		_mc.lineTo (startX,startY);
		_mc.endFill ();
	}
	//usage would be fillHexagon(sideLength, startX , start Y)	
}