package com.sulake.core.runtime;

typedef DependencySetter = Dynamic -> Void;

class ComponentDependency {
    public var identifier(get, never):IID;
    public var dependencySetter(get, never):Null<DependencySetter>;
    public var isRequired(get, never):Bool;
    public var eventListeners(get, never):Null<Array<Dynamic>>;

    private final _identifier:IID;
    private final _dependencySetter:Null<DependencySetter>;
    private final _isRequired:Bool;
    private final _eventListeners:Null<Array<Dynamic>>;

    public function new(
        identifier:IID,
        dependencySetter:Null<DependencySetter>,
        isRequired:Bool = true,
        ?eventListeners:Array<Dynamic>
    ) {
        _identifier = identifier;
        _dependencySetter = dependencySetter;
        _isRequired = isRequired;
        _eventListeners = eventListeners;
    }

    private inline function get_identifier():IID {
        return _identifier;
    }

    private inline function get_dependencySetter():Null<DependencySetter> {
        return _dependencySetter;
    }

    private inline function get_isRequired():Bool {
        return _isRequired;
    }

    private inline function get_eventListeners():Null<Array<Dynamic>> {
        return _eventListeners;
    }
}
