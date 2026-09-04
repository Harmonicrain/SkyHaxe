package com.sulake.core.window;

import haxe.ds.StringMap;
import openfl.display.DisplayObject;

/**
 * Minimal stable window surface shared by the Phase 2 XML/parser canaries.
 * M2 must reconcile this partial surface with the complete 2016 IWindow API;
 * a matching class name is not evidence that the original API is complete.
 */
interface IWindow extends com.sulake.core.runtime.IDisposable {
    public var typeName(default, null):String;
    public var caption(default, null):String;
    public var style(default, null):Int;
    public var param(default, null):Int;
    public var windowId(default, null):Int;
    public var layoutWidth(default, null):Float;
    public var layoutHeight(default, null):Float;
    public var minWidth(default, null):Null<Float>;
    public var maxWidth(default, null):Null<Float>;
    public var minHeight(default, null):Null<Float>;
    public var maxHeight(default, null):Null<Float>;
    public var properties(default, null):StringMap<Dynamic>;

    // findChildByName is deliberately absent: IWindow.as does not declare it. It belongs to
    // IWindowContainer, which declares it returning IWindow, and the port's callers all hold a
    // concrete WindowController anyway. Declaring it here with a narrower return type made the
    // generated IWindowContainer fail to satisfy its own base interface.
    public function displayObject():DisplayObject;
}
