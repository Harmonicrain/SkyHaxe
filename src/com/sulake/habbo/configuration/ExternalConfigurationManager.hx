package com.sulake.habbo.configuration;

#if html5
import com.sulake.core.runtime.Component;
import com.sulake.core.runtime.IContext;
import openfl.events.Event;

/**
 * HTML5 transport for the original configuration-manager contract.
 *
 * The AIR client receives the same flat external-variables table through its configuration
 * component. SkyHaxe has already downloaded that table before components are created, so this
 * adapter exposes it through the original interface and lifecycle instead of inventing defaults.
 */
class ExternalConfigurationManager extends Component {
    final _variables:ExternalVariables;

    public function new(context:IContext, variables:ExternalVariables) {
        _variables = variables;
        super(context);
    }

    /** Dispatch after dependants have attached their original Event.COMPLETE listeners. */
    public function announceComplete():Void events.dispatchEvent(new Event(Event.COMPLETE));

    override public function propertyExists(key:String):Bool
        return _variables.values.exists(key);

    override public function getProperty(key:String,
            ?substitutions:ASDictionary<ASAny, ASAny>):String {
        var value = _variables.get(key);
        if (substitutions != null) {
            for (name in substitutions.keys())
                value = StringTools.replace(value, "%" + Std.string(name) + "%",
                    Std.string(substitutions[name]));
        }
        return value;
    }

    override public function setProperty(key:String, value:String, persist:Bool = false,
            overwrite:Bool = false):Void {
        if (overwrite || !_variables.values.exists(key)) _variables.values.set(key, value);
    }

    override public function getBoolean(key:String):Bool {
        return switch (_variables.get(key).toLowerCase()) {
            case "1", "true", "yes", "on": true;
            default: false;
        };
    }

    override public function getInteger(key:String, fallback:Int):Int {
        var parsed = Std.parseInt(_variables.get(key));
        return parsed == null ? fallback : parsed;
    }

    override public function interpolate(text:String):String {
        if (text == null || text.indexOf("${") < 0) return text;
        var result = text;
        for (key in _variables.values.keys())
            result = StringTools.replace(result, "${" + key + "}", _variables.get(key));
        return result;
    }

    override public function updateUrlProtocol(url:String):String {
        if (url == null) return "";
        #if js
        if (js.Browser.window.location.protocol == "https:")
            return ~/^http:\/\//.replace(url, "https://");
        #end
        return url;
    }
}
#end
