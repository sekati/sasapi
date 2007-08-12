/** * com.sekati.geom.Point3D * @version 1.0.3 * @author jason m horwitz | sekati.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */import com.sekati.geom.Point;import com.sekati.geom.TrigoBase;/** * extend {@link com.sekati.geom.Point} with a Z-axis. *  * {@code Usage: * var Point:Point3D = new com.sekati.geom.Point3D(10,10,50); * } *///class com.sekati.geom.Point3D extends Point {	public var x:Number;	public var y:Number;	public var z:Number;	/**  	 * Constructor	 * @param nX (Number)	 * @param nY (Number)	 * @param nZ (Number)	 */	public function Point3D (nX:Number, nY:Number, nZ:Number) {		super(nX, nY);		z = nZ;	}	/**	 * check if two 3D points match	 * @param p (Point3D)	 * @return Boolean	 */	public function isEqual (p:Point3D):Boolean {		return (p.x == x && p.y == y && p.z == z);	}	/**	 * get Z distance between two points	 * @param p (Point3D)	 * @return Number	 */	public function getZDistance (p:Point3D):Number {		return TrigoBase.getZDistance (this, p);	}	/**	 * Returns a new 3D point based on this point with x and y offset values	 * @param nX (Number)	 * @param nY (Number)	 * @param nZ (Number)	 * @return Point3D	 */	public function displace (nX:Number, nY:Number, nZ:Number):Point3D {		return new Point3D (x + nX, y + nY, z + nZ);	}		/**	 * Offset the Point3D object by a specified amount.	 * @param x (Number) horizontal offset	 * @param y (Number) vertical offset	 * @param z (Number) z-axis offset	 * @return Void	 */	public function offset(x:Number, y:Number, z:Number):Void {		super.offset(x, y);		this.z += z;	}			/**	 * Clone this Point3D.	 * @return Point3D	 */	public function clone ():Point3D {		return new Point3D (this.x, this.y, this.z);	}		/**	 * Destroy this Point3D.	 * @return Void	 */	public function destroy ():Void {		delete this.z;		super.destroy();	}			/**	 * toString rewrite for a useful trace on the instance	 * @return String	 */	public function toString ():String {		return "Point:{x:" + x + ", y:" + y + ", z:" + z + "};";	}}