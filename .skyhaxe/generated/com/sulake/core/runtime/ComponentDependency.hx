package com.sulake.core.runtime
;
     class ComponentDependency 
    {
        var _identifier:IID;
        var _dependencySetter:ASFunction;
        var _isRequired:Bool = false;
        var _eventListeners:Array<ASAny>;

        public function new(identifier:IID, dependecySetter:ASFunction, isRequired:Bool=true, eventListeners:Array<ASAny>=null)
        {
            this._identifier = identifier;
            this._dependencySetter = dependecySetter;
            this._isRequired = isRequired;
            this._eventListeners = eventListeners;
        }

        @:allow(com.sulake.core.runtime) var identifier(get,never):IID;
function  get_identifier():IID
        {
            return this._identifier;
        }

        @:allow(com.sulake.core.runtime) var dependencySetter(get,never):ASFunction;
function  get_dependencySetter():ASFunction
        {
            return this._dependencySetter;
        }

        @:allow(com.sulake.core.runtime) var isRequired(get,never):Bool;
function  get_isRequired():Bool
        {
            return this._isRequired;
        }

        @:allow(com.sulake.core.runtime) var eventListeners(get,never):Array<ASAny>;
function  get_eventListeners():Array<ASAny>
        {
            return this._eventListeners;
        }
    }

