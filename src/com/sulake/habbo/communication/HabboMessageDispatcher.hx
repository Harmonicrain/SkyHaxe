package com.sulake.habbo.communication;

import com.sulake.core.communication.messages.IMessageDataWrapper;
import com.sulake.core.communication.wireformat.EvaMessageDataWrapper;
import haxe.ds.IntMap;
import js.lib.ArrayBuffer;

/** Packet-id dispatch separated from the HTML5 transport boundary. */
class HabboMessageDispatcher {
    final handlers = new IntMap<Array<IMessageDataWrapper->Void>>();
    final observers = new IntMap<Array<IMessageDataWrapper->Void>>();

    public function new() {}

    public function register(id:Int, handler:IMessageDataWrapper->Void):Void {
        var list = handlers.get(id);
        if (list == null) {
            list = [];
            handlers.set(id, list);
        }
        if (list.indexOf(handler) < 0) list.push(handler);
    }

    public function unregister(id:Int, handler:IMessageDataWrapper->Void):Void {
        var list = handlers.get(id);
        if (list == null) return;
        list.remove(handler);
        if (list.length == 0) handlers.remove(id);
    }

    /**
     * Observe a packet without claiming it.
     *
     * Generated message handlers remain the sole state-changing owner for room packets. Small
     * host UI pieces may still need a read-only view of the same payload (the current user's
     * figure feeds the temporary me-menu portrait), so observers receive their own wrapper and
     * cannot consume or replace the owner's parser.
     */
    public function observe(id:Int, observer:IMessageDataWrapper->Void):Void {
        var list = observers.get(id);
        if (list == null) {
            list = [];
            observers.set(id, list);
        }
        list.push(observer);
    }

    public function dispatch(id:Int, packet:ArrayBuffer):Bool {
        var handled = false;
        var packetObservers = observers.get(id);
        if (packetObservers != null) for (observer in packetObservers) {
            observer(new EvaMessageDataWrapper(id, packet));
            handled = true;
        }
        var listeners = handlers.get(id);
        if (listeners != null) {
            for (handler in listeners.copy()) {
                // A callback may unsubscribe another listener while handling this packet.
                if (listeners.indexOf(handler) < 0) continue;
                handler(new EvaMessageDataWrapper(id, packet));
                handled = true;
            }
        }
        return handled;
    }
}
