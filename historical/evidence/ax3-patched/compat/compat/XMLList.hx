package compat;

import Xml as StdXml;

private typedef XMLListImpl = #if flash flash.xml.XMLList #else Array<XML> #end;

abstract XMLList(XMLListImpl) from XMLListImpl to XMLListImpl {
	public function child(name:String):XMLList {
		#if flash
		return this.child(name);
		#else
		return [for (x in this) for (child in (x : StdXml).elementsNamed(name)) child];
		#end
	}

	public function filterAttributeEquals(name:String, value:String):XMLList {
		#if flash
		return [for (x in new std.NativeValueIterator<XML>(this))
			if (x.attribute(name).toString() == value) x];
		#else
		return [for (x in this) if ((x : StdXml).get(name) == value) x];
		#end
	}

	/** AS3 describeType query: descendants that are variables or readable accessors. */
	public function filterVariablesAndReadableAccessors():XMLList {
		#if flash
		return [for (x in new std.NativeValueIterator<XML>(this))
			if (x.localName() == "variable" || (x.localName() == "accessor" && x.attribute("access").charAt(0) == "r")) x];
		#else
		return [for (x in this)
			if (x.localName() == "variable" || (x.localName() == "accessor" && x.attribute("access").charAt(0) == "r")) x];
		#end
	}

	#if flash inline #end
	public function attribute(name:String):String {
		#if flash
		return this.attribute(name).toString();
		#else
		return [for (x in this) x.attribute(name)].join("");
		#end
	}

	#if flash inline #end
	public function toXMLString():String {
		#if flash
		return this.toXMLString();
		#else
		return [for (x in this) x.toXMLString()].join("\n");
		#end
	}

	#if flash inline #end
	public function toString():String {
		#if flash
		return this.toString();
		#else
		return if (this.length > 1) toXMLString() else this[0].toString();
		#end
	}

	@:op([]) inline function get(index:Int):XML {
		return this[index];
	}

	public inline function length():Int {
		#if flash
		return this.length();
		#else
		return this.length;
		#end
	}

	public inline function iterator() {
		#if flash
		return new std.NativeValueIterator<XML>(this);
		#else
		return this.iterator();
		#end
	}
}
