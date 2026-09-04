package com.sulake.habbo.communication;

import com.sulake.core.communication.messages.IMessageDataWrapper;
import com.sulake.core.communication.wireformat.EvaMessageDataWrapper;
import haxe.ds.IntMap;
import js.lib.ArrayBuffer;

/** Packet-id dispatch separated from the HTML5 transport boundary. */
class HabboMessageDispatcher {
    final handlers = new IntMap<IMessageDataWrapper->Void>();
    final observers = new IntMap<Array<IMessageDataWrapper->Void>>();

    public function new() {}

    public function register(id:Int, handler:IMessageDataWrapper->Void):Void {
        if (handlers.exists(id)) throw 'A handler is already registered for packet $id';
        handlers.set(id, handler);
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
        var handler = handlers.get(id);
        if (handler != null) {
            handler(new EvaMessageDataWrapper(id, packet));
            handled = true;
        }
        return handled;
    }
}
