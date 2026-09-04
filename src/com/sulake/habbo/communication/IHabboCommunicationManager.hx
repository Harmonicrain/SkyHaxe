package com.sulake.habbo.communication;

#if html5
import com.sulake.core.communication.connection.IConnection;
import com.sulake.core.runtime.IUnknown;

/**
 * RoomEngine's transport seam on HTML5.
 *
 * The AS3 interface also constructs the socket, DH exchange and RC4 ciphers.  Those belong to
 * Html5HabboConnection in this target; RoomEngine only consumes the authenticated IConnection so
 * carrying the factory half across would pull the obsolete hurlant handshake into the room
 * closure.
 */
interface IHabboCommunicationManager extends IUnknown {
    var connection(get, never):IConnection;
}
#end
