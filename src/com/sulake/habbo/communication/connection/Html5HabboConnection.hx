package com.sulake.habbo.communication.connection;

#if html5
import js.Browser;
import js.html.BinaryType;
import js.html.CloseEvent;
import js.html.MessageEvent;
import js.html.TextDecoder;
import js.html.TextEncoder;
import js.html.WebSocket;
import js.lib.ArrayBuffer;
import js.lib.DataView;
import js.lib.Uint8Array;

typedef Html5HabboConnectionCallbacks = {
    function onStatus(message:String):Void;
    function onPacket(header:Int, packet:ArrayBuffer):Void;
    function onAuthenticated(username:String):Void;
    function onClosed(code:Int, clean:Bool):Void;
    function onError(message:String):Void;
}

enum HabboMessageField {
    Int32(value:Int);
    String16(value:String);
    Bool8(value:Bool);
}

/**
 * Browser transport boundary for the Habbo connection.
 *
 * The packet ids and opening order are the same contract used by the clean client's
 * HabboCommunicationDemo and HabboMessages. WebSocket framing itself remains an HTML5 adapter;
 * protocol/domain code must not depend on js.html.WebSocket directly.
 */
class Html5HabboConnection {
    static inline var CLIENT_HELLO:Int = 4000;
    static inline var UNIQUE_ID:Int = 2490;
    static inline var SSO_TICKET:Int = 2419;
    static inline var INFO_RETRIEVE:Int = 357;
    static inline var PONG:Int = 2596;

    static inline var UNIQUE_MACHINE_ID:Int = 1488;
    static inline var AUTHENTICATION_OK:Int = 2491;
    static inline var USER_OBJECT:Int = 2725;
    static inline var PING:Int = 3928;

    static inline var CLIENT_VERSION:String = "PRODUCTION-201611291003-338511768";
    static inline var TIMEOUT_MS:Int = 15000;

    public var authenticated(default, null):Bool = false;
    public var username(default, null):Null<String>;

    final endpoint:String;
    final callbacks:Html5HabboConnectionCallbacks;
    var socket:Null<WebSocket>;
    var ssoTicket:String = "";
    var authenticationRequested:Bool = false;
    var userRequested:Bool = false;
    var timeoutId:Int = 0;
    var terminal:Bool = false;

    public function new(endpoint:String, callbacks:Html5HabboConnectionCallbacks) {
        this.endpoint = endpoint;
        this.callbacks = callbacks;
    }

    public function connect(ticket:String):Void {
        if (socket != null && socket.readyState < WebSocket.CLOSING) {
            callbacks.onError("A connection attempt is already active.");
            return;
        }
        ssoTicket = StringTools.trim(ticket);
        if (ssoTicket == "") {
            callbacks.onError("Enter an SSO ticket.");
            return;
        }
        authenticated = false;
        username = null;
        authenticationRequested = false;
        userRequested = false;
        terminal = false;
        callbacks.onStatus('Connecting to $endpoint');

        try {
            socket = new WebSocket(endpoint);
            socket.binaryType = BinaryType.ARRAYBUFFER;
            socket.onopen = onOpen;
            socket.onmessage = onMessage;
            socket.onerror = function(_) {
                if (!terminal) callbacks.onStatus("WebSocket error; waiting for close details.");
            };
            socket.onclose = onClose;
            timeoutId = Browser.window.setTimeout(onTimeout, TIMEOUT_MS);
        } catch (error:Dynamic) {
            fail('WebSocket construction failed: $error');
        }
    }

    public function close(reason:String = "Client closed connection"):Void {
        clearTimeout();
        if (socket != null && socket.readyState < WebSocket.CLOSING) socket.close(1000, reason);
    }

    public function sendMessage(header:Int, fields:Array<HabboMessageField>):Void {
        sendBytes(header, fields);
    }

    function onOpen(_):Void {
        callbacks.onStatus("Connected; sending client identity.");
        sendStrings(CLIENT_HELLO, [CLIENT_VERSION]);
        sendStrings(UNIQUE_ID, ["~skyhaxe-html5", "skyhaxe-html5", "HTML5"]);
    }

    function onMessage(event:MessageEvent):Void {
        if (!Std.isOfType(event.data, ArrayBuffer)) {
            fail("Server returned a non-binary WebSocket frame.");
            return;
        }
        var buffer:ArrayBuffer = cast event.data;
        var view = new DataView(buffer);
        if (view.byteLength < 6) {
            fail('Server packet is too short: ${view.byteLength} bytes.');
            return;
        }
        var declaredLength = view.getUint32(0, false);
        if (declaredLength != view.byteLength - 4) {
            fail('Server packet length mismatch: declared $declaredLength, actual ${view.byteLength - 4}.');
            return;
        }

        var header = view.getUint16(4, false);
        callbacks.onPacket(header, buffer);
        switch (header) {
            case UNIQUE_MACHINE_ID:
                handleUniqueMachineId(buffer, view);
            case AUTHENTICATION_OK:
                if (!authenticationRequested) {
                    fail("AuthenticationOK arrived before SSO was sent.");
                    return;
                }
                userRequested = true;
                callbacks.onStatus("Authenticated; requesting user identity.");
                sendStrings(INFO_RETRIEVE, []);
            case USER_OBJECT:
                handleUserObject(buffer, view);
            case PING:
                sendStrings(PONG, []);
            default:
                // The authenticated server sends the normal bootstrap stream here. Message
                // dispatch is the next vertical slice; ignoring unknown ids keeps this transport
                // boundary honest without encoding feature behavior in it.
        }
    }

    function handleUniqueMachineId(buffer:ArrayBuffer, view:DataView):Void {
        if (view.byteLength < 8) {
            fail("UniqueMachineID packet is too short.");
            return;
        }
        var length = view.getUint16(6, false);
        if (8 + length != view.byteLength) {
            fail("UniqueMachineID string length does not match its packet.");
            return;
        }
        var value = new TextDecoder().decode(new Uint8Array(buffer, 8, length));
        if (!~/^[0-9a-fA-F]{64}$/.match(value)) {
            fail("UniqueMachineID is not the expected 64-character hex value.");
            return;
        }
        authenticationRequested = true;
        callbacks.onStatus("Opening reply received; submitting SSO ticket.");
        sendStrings(SSO_TICKET, [ssoTicket]);
    }

    function handleUserObject(buffer:ArrayBuffer, view:DataView):Void {
        if (!userRequested || view.byteLength < 12) {
            fail("UserObject arrived before the authenticated identity request.");
            return;
        }
        var length = view.getUint16(10, false);
        if (12 + length > view.byteLength) {
            fail("UserObject username length exceeds its packet.");
            return;
        }
        username = new TextDecoder().decode(new Uint8Array(buffer, 12, length));
        authenticated = true;
        clearTimeout();
        callbacks.onAuthenticated(username);
    }

    function sendStrings(header:Int, strings:Array<String>):Void {
        sendBytes(header, [for (value in strings) String16(value)]);
    }

    function sendBytes(header:Int, fields:Array<HabboMessageField>):Void {
        if (socket == null || socket.readyState != WebSocket.OPEN) {
            fail('Cannot send packet $header while the socket is not open.');
            return;
        }
        socket.send(packet(header, fields));
    }

    function onClose(event:CloseEvent):Void {
        clearTimeout();
        socket = null;
        callbacks.onClosed(event.code, event.wasClean);
    }

    function onTimeout():Void {
        timeoutId = 0;
        fail('Connection timed out after $TIMEOUT_MS ms.');
    }

    function fail(message:String):Void {
        if (terminal) return;
        terminal = true;
        clearTimeout();
        callbacks.onError(message);
        if (socket != null && socket.readyState < WebSocket.CLOSING) socket.close();
    }

    function clearTimeout():Void {
        if (timeoutId == 0) return;
        Browser.window.clearTimeout(timeoutId);
        timeoutId = 0;
    }

    static function packet(header:Int, fields:Array<HabboMessageField>):ArrayBuffer {
        var encoder = new TextEncoder();
        var bodyLength = 2;
        for (field in fields) bodyLength += switch (field) {
            case Int32(_): 4;
            case Bool8(_): 1;
            case String16(value): 2 + encoder.encode(value).byteLength;
        }

        var output = new Uint8Array(4 + bodyLength);
        var view = new DataView(output.buffer);
        view.setUint32(0, bodyLength, false);
        view.setUint16(4, header, false);
        var offset = 6;
        for (field in fields) switch (field) {
            case Int32(value):
                view.setInt32(offset, value, false);
                offset += 4;
            case Bool8(value):
                view.setUint8(offset++, value ? 1 : 0);
            case String16(value):
                var encoded = encoder.encode(value);
                view.setUint16(offset, encoded.byteLength, false);
                offset += 2;
                output.set(encoded, offset);
                offset += encoded.byteLength;
        }
        return output.buffer;
    }
}
#end
