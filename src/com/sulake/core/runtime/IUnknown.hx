package com.sulake.core.runtime;

/**
 * A callback that receives a resolved interface.
 *
 * IUnknown.as types this as a bare `Function`, and the converter emits `ASFunction` at every call
 * site, so the signature below is the one the generated components pass. The named typedef stays
 * because the hand-written broker reads far better with it.
 */
typedef InterfaceReceiver = (identifier:IID, unknown:IUnknown) -> Void;

/**
 * A seam over com.sulake.core.runtime.IUnknown, matching its two members exactly.
 *
 * `queueInterface` is declared with ASFunction rather than InterfaceReceiver because AS3 declares
 * it as `Function`: a converted component that passes a differently-shaped closure is legal there
 * and has to stay legal here, or every generated `queueInterface` call fails to unify.
 */
interface IUnknown extends IDisposable {
    public function queueInterface(identifier:IID, ?receiver:ASFunction):Null<IUnknown>;

    public function release(identifier:IID):Int;
}
