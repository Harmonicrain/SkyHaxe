package com.sulake.core.utils.xml;

/**
 * Small E4X compatibility node backed by Haxe's cross-target Xml tree.
 *
 * Dynamic E4X syntax is converted explicitly: `xml.childName` becomes
 * `xml.child("childName")`, and `xml.@id` becomes `xml.attribute("id")`.
 */
class XML {
    @:allow(com.sulake.core.utils.xml.XMLList)
    private var _node:Null<Xml>;

    private var _attributeOwner:Null<Xml>;
    private var _attributeName:Null<String>;

    public function new(?value:Dynamic) {
        if (value == null || Std.string(value) == "") {
            _node = Xml.createDocument();
            return;
        }

        if (Std.isOfType(value, XML)) {
            var other:XML = cast value;
            if (other.isAttribute()) {
                _attributeOwner = other._attributeOwner;
                _attributeName = other._attributeName;
            } else {
                _node = cloneNative(other.requireNode());
            }
            return;
        }

        if (Std.isOfType(value, Xml)) {
            _node = cast value;
            return;
        }

        var document = Xml.parse(Std.string(value));
        var first = firstSignificantChild(document);
        _node = first == null ? document : first;
    }

    public static function fromNative(node:Xml):XML {
        var result = new XML();
        result._node = node;
        return result;
    }

    /** AS3 `XML(value)` coercion: retain an existing node instead of copying it. */
    public static function coerce(value:Dynamic):XML {
        if (Std.isOfType(value, XML)) {
            return cast value;
        }
        if (Std.isOfType(value, XMLList)) {
            var list:XMLList = cast value;
            var first = list.at(0);
            return first == null ? new XML() : first;
        }
        if (Std.isOfType(value, Xml)) {
            return fromNative(cast value);
        }
        return new XML(value);
    }

    private static function fromAttribute(owner:Xml, name:String):XML {
        var result = new XML();
        result._node = null;
        result._attributeOwner = owner;
        result._attributeName = name;
        return result;
    }

    public function length():Int {
        return 1;
    }

    public function at(index:Int):Null<XML> {
        return index == 0 ? this : null;
    }

    public function child(name:String):XMLList {
        if (isAttribute()) {
            return new XMLList();
        }
        var result:Array<XML> = [];
        var node = requireNode();
        if (!isContainer(node)) {
            return new XMLList(result);
        }
        for (candidate in node) {
            if (candidate.nodeType == Xml.Element && (name == "*" || candidate.nodeName == name)) {
                result.push(fromNative(candidate));
            }
        }
        return new XMLList(result);
    }

    public function children():XMLList {
        if (isAttribute()) {
            return new XMLList();
        }
        var result:Array<XML> = [];
        var node = requireNode();
        if (!isContainer(node)) {
            return new XMLList(result);
        }
        for (candidate in node) {
            if (!isIgnoredNode(candidate)) {
                result.push(fromNative(candidate));
            }
        }
        return new XMLList(result);
    }

    public function text():XMLList {
        if (isAttribute()) {
            return new XMLList();
        }
        var result:Array<XML> = [];
        var node = requireNode();
        if (!isContainer(node)) {
            return new XMLList(result);
        }
        for (candidate in node) {
            if ((candidate.nodeType == Xml.PCData || candidate.nodeType == Xml.CData)
                && !isIgnoredNode(candidate)) {
                result.push(fromNative(candidate));
            }
        }
        return new XMLList(result);
    }

    public function attribute(name:String):XMLList {
        if (isAttribute()) {
            return new XMLList();
        }
        var node = requireNode();
        if (node.nodeType != Xml.Element) {
            return new XMLList();
        }
        var result:Array<XML> = [];
        if (name == "*") {
            for (attributeName in node.attributes()) {
                result.push(fromAttribute(node, attributeName));
            }
        } else if (node.exists(name)) {
            result.push(fromAttribute(node, name));
        }
        return new XMLList(result);
    }

    public function setAttribute(name:String, value:Dynamic):XML {
        var node = requireElement();
        node.set(name, Std.string(value));
        return this;
    }

    public function name():Null<String> {
        if (isAttribute()) {
            return _attributeName;
        }
        var node = requireNode();
        return node.nodeType == Xml.Element ? node.nodeName : null;
    }

    public function localName():Null<String> {
        var qualified = name();
        if (qualified == null) {
            return null;
        }
        var separator = qualified.indexOf(":");
        return separator == -1 ? qualified : qualified.substr(separator + 1);
    }

    public function parent():Null<XML> {
        if (isAttribute()) {
            return _attributeOwner == null ? null : fromNative(_attributeOwner);
        }
        var node = requireNode();
        return node.parent == null || node.parent.nodeType == Xml.Document
            ? null
            : fromNative(node.parent);
    }

    public function hasOwnProperty(property:String):Bool {
        if (StringTools.startsWith(property, "@")) {
            return attribute(property.substr(1)).length() > 0;
        }
        var index = Std.parseInt(property);
        if (index != null && Std.string(index) == property) {
            return index == 0;
        }
        return child(property).length() > 0;
    }

    public function appendChild(value:Dynamic):XML {
        var parent = requireContainer();
        if (Std.isOfType(value, XMLList)) {
            var list:XMLList = cast value;
            for (item in list) {
                appendChild(item);
            }
        } else if (Std.isOfType(value, XML)) {
            var child:XML = cast value;
            if (child.isAttribute()) {
                throw new haxe.Exception("Cannot append an XML attribute as a child");
            }
            parent.addChild(child.requireNode());
        } else if (Std.isOfType(value, Xml)) {
            parent.addChild(cast value);
        } else {
            parent.addChild(Xml.createPCData(Std.string(value)));
        }
        return this;
    }

    public function replace(property:Dynamic, value:Dynamic):XML {
        var parent = requireContainer();
        var candidates = [for (child in parent) child];
        var replacement = nodesFrom(value);
        var indexes:Array<Int> = [];
        var numeric = Std.parseInt(Std.string(property));
        if (numeric != null && Std.string(numeric) == Std.string(property)) {
            if (numeric >= 0 && numeric < candidates.length) {
                indexes.push(numeric);
            }
        } else {
            for (index in 0...candidates.length) {
                var candidate = candidates[index];
                if (candidate.nodeType == Xml.Element && candidate.nodeName == Std.string(property)) {
                    indexes.push(index);
                }
            }
        }

        if (indexes.length == 0) {
            return this;
        }

        var insertionIndex = indexes[0];
        for (offset in 0...indexes.length) {
            parent.removeChild(candidates[indexes[indexes.length - 1 - offset]]);
        }
        for (index in 0...replacement.length) {
            parent.insertChild(replacement[index], insertionIndex + index);
        }
        return this;
    }

    public function copy():XML {
        if (isAttribute()) {
            var owner = Xml.createElement("attribute");
            owner.set(_attributeName, attributeValue());
            return fromAttribute(owner, _attributeName);
        }
        return fromNative(cloneNative(requireNode()));
    }

    public function toXMLString():String {
        if (isAttribute()) {
            return '${_attributeName}="${escapeAttribute(attributeValue())}"';
        }
        return requireNode().toString();
    }

    public function toString():String {
        if (isAttribute()) {
            return attributeValue();
        }
        var node = requireNode();
        return switch (node.nodeType) {
            case Xml.PCData, Xml.CData: node.nodeValue;
            case Xml.Element:
                if (hasElementChild(node)) {
                    node.toString();
                } else {
                    collectSimpleText(node);
                }
            case Xml.Document:
                var first = firstSignificantChild(node);
                first == null ? "" : fromNative(first).toString();
            default: node.nodeValue;
        };
    }

    private function isAttribute():Bool {
        return _attributeOwner != null && _attributeName != null;
    }

    private function attributeValue():String {
        if (_attributeOwner == null || _attributeName == null) {
            return "";
        }
        var value = _attributeOwner.get(_attributeName);
        return value == null ? "" : value;
    }

    private function requireNode():Xml {
        if (_node == null) {
            throw new haxe.Exception("XML attribute has no standalone native node");
        }
        return _node;
    }

    private function requireElement():Xml {
        var node = requireNode();
        if (node.nodeType != Xml.Element) {
            throw new haxe.Exception("XML operation requires an element");
        }
        return node;
    }

    private function requireContainer():Xml {
        var node = requireNode();
        if (!isContainer(node)) {
            throw new haxe.Exception("XML operation requires an element or document");
        }
        return node;
    }

    private static function isContainer(node:Xml):Bool {
        return node.nodeType == Xml.Element || node.nodeType == Xml.Document;
    }

    private static function isIgnoredNode(node:Xml):Bool {
        if (node.nodeType == Xml.Comment || node.nodeType == Xml.ProcessingInstruction) {
            return true;
        }
        return node.nodeType == Xml.PCData && StringTools.trim(node.nodeValue) == "";
    }

    private static function firstSignificantChild(document:Xml):Null<Xml> {
        if (!isContainer(document)) {
            return document;
        }
        for (child in document) {
            if (!isIgnoredNode(child)) {
                return child;
            }
        }
        return null;
    }

    private static function hasElementChild(node:Xml):Bool {
        for (child in node) {
            if (child.nodeType == Xml.Element) {
                return true;
            }
        }
        return false;
    }

    private static function collectSimpleText(node:Xml):String {
        var buffer = new StringBuf();
        for (child in node) {
            if (child.nodeType == Xml.PCData || child.nodeType == Xml.CData) {
                buffer.add(child.nodeValue);
            }
        }
        return buffer.toString();
    }

    private static function nodesFrom(value:Dynamic):Array<Xml> {
        if (Std.isOfType(value, XMLList)) {
            var list:XMLList = cast value;
            return [for (item in list) cloneNative(item.requireNode())];
        }
        if (Std.isOfType(value, XML)) {
            var xml:XML = cast value;
            return [cloneNative(xml.requireNode())];
        }
        if (Std.isOfType(value, Xml)) {
            return [cloneNative(cast value)];
        }
        return [Xml.createPCData(Std.string(value))];
    }

    private static function cloneNative(node:Xml):Xml {
        var copy:Xml;
        if (node.nodeType == Xml.Element) {
            copy = Xml.createElement(node.nodeName);
            for (attributeName in node.attributes()) {
                copy.set(attributeName, node.get(attributeName));
            }
        } else if (node.nodeType == Xml.PCData) {
            copy = Xml.createPCData(node.nodeValue);
        } else if (node.nodeType == Xml.CData) {
            copy = Xml.createCData(node.nodeValue);
        } else if (node.nodeType == Xml.Comment) {
            copy = Xml.createComment(node.nodeValue);
        } else if (node.nodeType == Xml.DocType) {
            copy = Xml.createDocType(node.nodeValue);
        } else if (node.nodeType == Xml.ProcessingInstruction) {
            copy = Xml.createProcessingInstruction(node.nodeValue);
        } else {
            copy = Xml.createDocument();
        }
        if (isContainer(node)) {
            for (child in node) {
                copy.addChild(cloneNative(child));
            }
        }
        return copy;
    }

    private static function escapeAttribute(value:String):String {
        return StringTools.replace(
            StringTools.replace(
                StringTools.replace(value, "&", "&amp;"),
                "\"",
                "&quot;"
            ),
            "<",
            "&lt;"
        );
    }
}
