package com.sulake.core.window.graphics;

import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;

private typedef SkinBinding = {
	var layout:String;
	var xml:Xml;
	var atlas:BitmapData;
}

private typedef SkinRect = {var x:Float; var y:Float; var width:Float; var height:Float;}

/** Data-driven renderer for the original client's bitmap skin XML. */
class WindowSkinRenderer {
	final bindings:Map<String, SkinBinding> = [];

	public function new() {}

	public function register(typeName:String, style:Int, layout:String, skinXml:String,
			atlas:BitmapData):Void {
		var document = Xml.parse(skinXml);
		var root = document.firstElement();
		if (root == null || root.nodeName != "skin") throw new haxe.Exception("invalid skin XML");
		bindings.set(key(typeName, style), {layout: layout, xml: root, atlas: atlas});
	}

	public function has(typeName:String, style:Int):Bool return bindings.exists(key(typeName, style));

	public function render(typeName:String, style:Int, width:Int, height:Int,
			state:String = "default", color:Int = 0xFFFFFF, background:Bool = false):Null<BitmapData> {
		var binding = bindings.get(key(typeName, style));
		if (binding == null) return null;
		return renderBinding(binding, width, height, state, color, background);
	}

	function renderBinding(binding:SkinBinding, width:Int, height:Int, state:String,
			color:Int, background:Bool):BitmapData {
		var templateName:String = null;
		var states = child(binding.xml, "states");
		if (states != null) for (node in states.elementsNamed("state")) {
			if (node.get("name") == state && node.get("layout") == binding.layout) {
				templateName = node.get("template");
				break;
			}
		}
		if (templateName == null && state != "default") return renderBinding(binding, width, height, "default", color, background);
		var output = new BitmapData(Std.int(Math.max(1, width)), Std.int(Math.max(1, height)), true, 0);
		if (templateName == null || templateName == "null") return output;

		var template = namedChild(child(binding.xml, "templates"), "template", templateName);
		var layout = namedChild(child(binding.xml, "layouts"), "layout", binding.layout);
		if (template == null || layout == null) throw new haxe.Exception('skin layout ${binding.layout} is incomplete');
		var sources = new Map<String, SkinRect>();
		var templateEntities = child(template, "entities");
		if (templateEntities != null) for (entity in templateEntities.elementsNamed("entity")) {
			var rect = rectangle(entity);
			if (rect != null) sources.set(entity.get("name"), rect);
		}
		var layoutEntities = child(layout, "entities");
		var baseWidth = 0.0;
		var baseHeight = 0.0;
		if (layoutEntities != null) for (entity in layoutEntities.elementsNamed("entity")) {
			var rect = rectangle(entity);
			if (rect != null) {
				baseWidth = Math.max(baseWidth, rect.x + rect.width);
				baseHeight = Math.max(baseHeight, rect.y + rect.height);
			}
		}
		var deltaWidth = width - baseWidth;
		var deltaHeight = height - baseHeight;
		if (layoutEntities != null) for (entity in layoutEntities.elementsNamed("entity")) {
			var source = sources.get(entity.get("name"));
			var destination = rectangle(entity);
			if (source == null || destination == null) continue;
			var scale = child(entity, "scale");
			var horizontal = scale == null ? "fixed" : scale.get("horizontal");
			var vertical = scale == null ? "fixed" : scale.get("vertical");
			if (horizontal == "strech" || horizontal == "stretch") destination.width += deltaWidth;
			else if (horizontal == "move") destination.x += deltaWidth;
			if (vertical == "strech" || vertical == "stretch") destination.height += deltaHeight;
			else if (vertical == "move") destination.y += deltaHeight;
			if (destination.width <= 0 || destination.height <= 0) continue;
			var matrix = new Matrix(destination.width / source.width, 0, 0,
				destination.height / source.height,
				destination.x - source.x * destination.width / source.width,
				destination.y - source.y * destination.height / source.height);
			var transform:Null<ColorTransform> = null;
			var colorize = entity.get("colorize") != "false";
			if (!background && colorize && (color & 0xFFFFFF) < 0xFFFFFF) {
				transform = new ColorTransform(((color >> 16) & 0xFF) / 255,
					((color >> 8) & 0xFF) / 255, (color & 0xFF) / 255, 1);
			}
			output.draw(binding.atlas, matrix, transform, null,
				new Rectangle(destination.x, destination.y, destination.width, destination.height), false);
		}
		return output;
	}

	static function rectangle(node:Xml):Null<SkinRect> {
		var region = child(node, "region");
		var rect = region == null ? null : child(region, "Rectangle");
		if (rect == null) return null;
		return {x: number(rect, "x"), y: number(rect, "y"),
			width: number(rect, "width"), height: number(rect, "height")};
	}

	static function child(node:Null<Xml>, name:String):Null<Xml> {
		if (node == null) return null;
		for (value in node.elementsNamed(name)) return value;
		return null;
	}

	static function namedChild(node:Null<Xml>, tag:String, name:String):Null<Xml> {
		if (node == null) return null;
		for (value in node.elementsNamed(tag)) if (value.get("name") == name) return value;
		return null;
	}

	static function number(node:Xml, attribute:String):Float {
		var parsed = Std.parseFloat(node.get(attribute));
		return Math.isNaN(parsed) ? 0 : parsed;
	}

	static inline function key(typeName:String, style:Int):String return '$typeName:$style';
}
