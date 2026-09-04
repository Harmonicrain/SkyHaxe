package com.sulake.habbo.communication;

#if html5
import com.sulake.core.communication.connection.IConnection;
import com.sulake.core.communication.encryption.IEncryption;
import com.sulake.core.communication.messages.IMessageComposer;
import com.sulake.core.communication.messages.IMessageConfiguration;
import com.sulake.core.communication.messages.IMessageEvent;
import com.sulake.core.communication.messages.IMessageParser;
import com.sulake.habbo.communication.connection.Html5HabboConnection;
import com.sulake.habbo.communication.connection.Html5HabboConnection.HabboMessageField;
import js.Browser;
import openfl.events.EventDispatcher;

/**
 * The connection the converted message handlers register against.
 *
 * A converted handler does not read packets. It hands the connection a list of `MessageEvent`s --
 * each pairing a parser class with a callback -- and waits to be called. That is the whole of its
 * relationship with the socket, which is why replacing the socket underneath it is enough to run
 * the client's own handlers unchanged.
 *
 * So this is not a port of `SocketConnection`: it owns no socket, no encryption and no send queue.
 * It is the adapter between the demo's dispatcher, which already reads frames off the WebSocket,
 * and the shape the converted code expects. Everything to do with actually being a connection is
 * refused rather than faked, because the demo is still the thing that connects.
 */
class SkyConnection extends EventDispatcher implements IConnection {
    final _dispatcher:HabboMessageDispatcher;
    /**
     * Where composers are written.
     *
     * A provider rather than the socket itself: the engine and its handler are built when the
     * external variables land, which is before the player has clicked login and the socket
     * exists. Holding the socket here would capture a null for the whole session.
     */
    final _socket:Void->Null<Html5HabboConnection>;
    /** Events whose class the registry does not know, reported once rather than per packet. */
    final _unmapped:Array<String> = [];
    var _disposed = false;

    public function new(dispatcher:HabboMessageDispatcher, socket:Void->Null<Html5HabboConnection>) {
        super();
        _dispatcher = dispatcher;
        _socket = socket;
    }

    /**
     * Route one message event.
     *
     * The event knows its parser class but not its packet id -- the client's own configuration
     * supplies that -- so the id comes from the generated registry, keyed by the event's class
     * name. An event the registry does not know is reported and dropped: silently ignoring it
     * would look exactly like a server that never sends that packet.
     */
    public function addMessageEvent(event:IMessageEvent):Void {
        if (event == null) return;
        var qualified = Type.getClassName(Type.getClass(event));
        var name = qualified.split(".").pop();
        var id = GeneratedHabboMessageRegistry.incomingId(name);
        if (id < 0) {
            if (_unmapped.indexOf(name) < 0) {
                _unmapped.push(name);
                Browser.console.warn('SKYHAXE_UNMAPPED_EVENT $name');
            }
            return;
        }
        event.connection = this;
        _dispatcher.register(id, function(wrapper) {
            // A fresh parser per packet: the client's own connection reuses one per event, but
            // reuse only matters when parsing is hot, and a shared parser holding the previous
            // packet's state is a class of bug not worth inviting.
            var parser:IMessageParser = cast Type.createInstance(event.parserClass, []);
            if (parser == null || !parser.parse(wrapper)) return;
            event.parser = parser;
            var callback = event.callback;
            if (callback != null) callback(event);
        });
    }

    public function removeMessageEvent(event:IMessageEvent):Void {
        // The demo's dispatcher holds one handler per id and nothing unregisters mid-session.
    }

    public var connected(get, never):Bool;
    inline function get_connected():Bool return !_disposed;

    public var disposed(get, never):Bool;
    inline function get_disposed():Bool return _disposed;

    public function dispose():Void {
        _disposed = true;
    }

    // Being a connection is the demo's job, not this adapter's. Each of these belongs to the
    // socket the demo already owns, so they refuse rather than pretend.
    public function init(_arg_1:String, _arg_2:UInt = 0):Bool return false;

    public var timeout(never, set):Int;
    inline function set_timeout(value:Int):Int return value;

    /**
     * Write a composer to the socket.
     *
     * A converted handler asks for what it needs rather than being handed it: RoomMessageHandler
     * answers RoomReady by sending `GetRoomEntryDataMessageComposer`, and the server sends the
     * height maps, objects and users only in reply to that. While this refused to send, the room
     * stream simply stopped after RoomReady and the screen stayed black.
     *
     * `IMessageComposer` carries no packet id -- in AS3 that comes from the message configuration
     * -- so it is looked up by class name in the generated registry, the same way incoming events
     * are.
     */
    public function send(composer:IMessageComposer):Bool {
        if (composer == null) return false;
        var socket = _socket();
        if (socket == null) return false;
        var name = Type.getClassName(Type.getClass(composer)).split(".").pop();
        var id = GeneratedHabboMessageRegistry.outgoingId(name);
        if (id < 0) {
            Browser.console.warn('SKYHAXE_UNMAPPED_COMPOSER $name');
            return false;
        }
        var fields:Array<HabboMessageField> = [];
        for (value in composer.getMessageArray()) {
            // The wire types the client's own composers produce. An unrecognised one is reported
            // rather than coerced, because a wrongly-typed field desynchronises everything after
            // it in the packet.
            if (Std.isOfType(value, Bool)) fields.push(Bool8(cast value));
            else if (Std.isOfType(value, Int)) fields.push(Int32(cast value));
            else if (Std.isOfType(value, String)) fields.push(String16(cast value));
            else if (Std.isOfType(value, Float)) fields.push(Int32(Std.int(cast(value, Float))));
            else {
                Browser.console.warn('SKYHAXE_UNSENDABLE_FIELD $name: ' + Std.string(value));
                return false;
            }
        }
        socket.sendMessage(id, fields);
        composer.dispose();
        return true;
    }

    public function sendUnencrypted(composer:IMessageComposer):Bool return send(composer);

    public function setEncryption(outgoing:IEncryption, incoming:IEncryption):Void {}

    public function getServerToClientEncryption():IEncryption return null;

    public function registerMessageClasses(_arg_1:IMessageConfiguration):Void {}

    public function processReceivedData():Void {}

    public function close():Void {}

    public function isAuthenticated():Void {}

    public function isConfigured():Void {}

    public function createSocket():Void {}
}
#end
