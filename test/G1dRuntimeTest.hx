import com.sulake.core.runtime.ComponentDependency;
import com.sulake.core.runtime.ComponentDependencyLifecycle;
import com.sulake.core.runtime.ComponentInterfaceQueue;
import com.sulake.core.runtime.ComponentInterfaceBroker;
import com.sulake.core.runtime.ComponentManifest;
import com.sulake.core.runtime.IID;
import com.sulake.core.runtime.IUnknown;
import com.sulake.core.runtime.InterfaceStruct;
import com.sulake.core.runtime.InterfaceStructList;
import com.sulake.core.runtime.IUnknown.InterfaceReceiver;
import com.sulake.core.utils.ClassUtils;
import com.sulake.core.utils.DefinitionRegistry;

class G1dRuntimeTest {
    private static var assertions:Int = 0;

    public static function main():Void {
        testInterfaceStruct();
        testInterfaceStructList();
        testDependencyAndQueueContracts();
        testComponentManifest();
        testDependencyLifecycle();
        testInterfaceBroker();
        trace('G1D_RUNTIME_PASS assertions=$assertions');
    }

    private static function testInterfaceStruct():Void {
        var implementor = new TestUnknown();
        var struct = new InterfaceStruct(new TestIID(), implementor);
        equal(false, struct.disposed, "new struct is live");
        equal(ClassUtils.getQualifiedClassName(new TestIID()), struct.iis, "identifier is stored by qualified class name");
        equal(0, struct.references, "new struct has no references");
        equal(1, struct.reserve(), "first reserve");
        equal(2, struct.reserve(), "second reserve");
        equal(1, struct.release(), "first release");
        equal(0, struct.release(), "second release");
        equal(0, struct.release(), "release floors at zero");
        struct.dispose();
        equal(true, struct.disposed, "disposed struct has no implementor");
        equal(0, struct.references, "dispose clears references");
    }

    private static function testInterfaceStructList():Void {
        var first = new TestUnknown();
        var second = new TestUnknown();
        var firstMain = new InterfaceStruct(new TestIID(), first);
        var firstAlt = new InterfaceStruct(new AlternateIID(), first);
        var secondMain = new InterfaceStruct(new TestIID(), second);
        var list = new InterfaceStructList();

        equal(1, list.insert(firstMain), "first insert length");
        equal(2, list.insert(firstAlt), "second insert length");
        equal(3, list.insert(secondMain), "third insert length");
        equal(first, list.find(new TestIID()), "separate IID instances match by class");
        equal(null, list.find(new MissingIID()), "unknown IID is absent");
        equal(0, list.getIndexByInterface(new TestIID()), "first interface index");
        equal(0, list.getIndexByImplementor(first), "AS3 returns first implementor index");

        var byInterface:Array<InterfaceStruct> = [];
        equal(2, list.mapStructsByInterface(new TestIID(), byInterface), "maps duplicate interface providers");
        equal(secondMain, byInterface[1], "interface mapping preserves list order");
        var byImplementor:Array<InterfaceStruct> = [];
        equal(2, list.mapStructsByImplementor(first, byImplementor), "maps implementor interfaces");
        equal(firstAlt, byImplementor[1], "implementor mapping preserves list order");

        firstMain.reserve();
        firstAlt.reserve();
        firstAlt.reserve();
        equal(3, list.getTotalReferenceCount(), "reference totals span structs");
        equal(firstAlt, list.getStructByIndex(1), "index lookup");
        equal(null, list.getStructByIndex(99), "out-of-range index lookup is null");
        equal(firstAlt, list.remove(1), "remove returns removed struct");
        equal(2, list.length, "remove shrinks list");

        var rangeThrew = false;
        try {
            list.remove(9);
        } catch (_:Dynamic) {
            rangeThrew = true;
        }
        equal(true, rangeThrew, "out-of-range remove throws");

        list.dispose();
        equal(true, list.disposed, "list dispose marker");
        equal(true, firstMain.disposed, "list disposes retained structs");
        equal(false, first.disposed, "struct disposal does not dispose implementor");
    }

    private static function testDependencyAndQueueContracts():Void {
        var iid = new TestIID();
        var injected:Dynamic = null;
        var listeners:Array<Dynamic> = [{type: "ready"}];
        var dependency = new ComponentDependency(iid, value -> injected = value, false, listeners);
        equal(iid, dependency.identifier, "dependency identifier");
        equal(false, dependency.isRequired, "optional dependency flag");
        equal(listeners, dependency.eventListeners, "listener array is preserved");
        dependency.dependencySetter("service");
        equal("service", injected, "dependency setter is callable");
        equal(true, new ComponentDependency(iid, null).isRequired, "dependency required by default");

        var queue = new ComponentInterfaceQueue(iid);
        var calls:Array<String> = [];
        var first:InterfaceReceiver = (_, _) -> calls.push("first");
        var second:InterfaceReceiver = (_, _) -> calls.push("second");
        queue.receivers.unshift(first);
        queue.receivers.unshift(second);
        equal(2, queue.receivers.length, "deferred receivers are retained");
        queue.receivers.pop()(iid, new TestUnknown());
        queue.receivers.pop()(iid, new TestUnknown());
        equal("first,second", calls.join(","), "unshift plus pop preserves registration order");
        queue.dispose();
        equal(true, queue.disposed, "queue dispose marker");
        equal(null, queue.identifier, "queue dispose clears identifier");
    }

    private static function testComponentManifest():Void {
        DefinitionRegistry.reset();
        DefinitionRegistry.register("com.sulake.bootstrap.TestBootstrap", TestBootstrap);
        DefinitionRegistry.register("com.sulake.iid.TestIID", TestIID);
        DefinitionRegistry.register("com.sulake.iid.AlternateIID", AlternateIID);
        var source = '<manifest><component class="com.sulake.bootstrap.TestBootstrap" version="1.2">'
            + '<interface iid="com.sulake.iid.TestIID"/>'
            + '<interface iid="com.sulake.iid.AlternateIID"/>'
            + '</component></manifest>';
        var entries = ComponentManifest.parse(source);
        equal(1, entries.length, "one manifest component");
        equal("com.sulake.bootstrap.TestBootstrap", entries[0].className, "component class name");
        equal("1.2", entries[0].version, "component version");
        equal("com.sulake.iid.TestIID,com.sulake.iid.AlternateIID", entries[0].interfaces.join(","), "ordered IID names");
        equal(TestBootstrap, ComponentManifest.resolveComponentClass(entries[0]), "component class resolution");
        var identifiers = ComponentManifest.instantiateIdentifiers(entries[0]);
        equal(2, identifiers.length, "identifier instances");
        equal(true, Std.isOfType(identifiers[0], TestIID), "first identifier type");
        equal(true, Std.isOfType(identifiers[1], AlternateIID), "second identifier type");

        var missingClassThrew = false;
        try {
            ComponentManifest.resolveComponentClass(ComponentManifest.parse(
                '<manifest><component class="missing.Component"/></manifest>'
            )[0]);
        } catch (_:Dynamic) {
            missingClassThrew = true;
        }
        equal(true, missingClassThrew, "missing component class fails explicitly");

        DefinitionRegistry.register("com.sulake.iid.NotAnIID", TestBootstrap);
        var invalidIidThrew = false;
        try {
            ComponentManifest.instantiateIdentifiers(ComponentManifest.parse(
                '<manifest><component class="com.sulake.bootstrap.TestBootstrap">'
                + '<interface iid="com.sulake.iid.NotAnIID"/>'
                + '</component></manifest>'
            )[0]);
        } catch (_:Dynamic) {
            invalidIidThrew = true;
        }
        equal(true, invalidIidThrew, "non-IID manifest class fails explicitly");

        var malformedThrew = false;
        try {
            ComponentManifest.parse('<manifest><component version="1"/></manifest>');
        } catch (_:Dynamic) {
            malformedThrew = true;
        }
        equal(true, malformedThrew, "component class attribute is required");
    }

    private static function testDependencyLifecycle():Void {
        var emptyReady = 0;
        var empty = new ComponentDependencyLifecycle([], (_, _) -> null, () -> emptyReady++);
        equal(1, emptyReady, "component without dependencies initializes immediately");
        equal(true, empty.initialized, "empty lifecycle initialized");
        equal(false, empty.locked, "empty lifecycle unlocked");

        var broker = new TestInterfaceBroker();
        var requiredValue:Dynamic = null;
        var optionalValue:Dynamic = "unset";
        var ready = 0;
        var attached:Array<String> = [];
        var detached:Array<String> = [];
        var requiredIID = new TestIID();
        var optionalIID = new AlternateIID();
        var lifecycle = new ComponentDependencyLifecycle([
            new ComponentDependency(requiredIID, value -> requiredValue = value, true, [{type: "ready"}]),
            new ComponentDependency(optionalIID, value -> optionalValue = value, false)
        ], broker.request, () -> ready++,
            (_, listener) -> attached.push(listener.type),
            (_, listener) -> detached.push(listener.type)
        );
        equal(true, lifecycle.locked, "missing required dependency keeps component locked");
        equal(false, lifecycle.initialized, "missing required dependency delays initialization");
        equal(0, ready, "ready callback delayed");
        equal(2, broker.pendingCount, "required and optional requests queued");

        var requiredService = new TestUnknown();
        broker.provide(new TestIID(), requiredService);
        equal(requiredService, requiredValue, "required dependency injected by IID class");
        equal("ready", attached.join(","), "dependency event listener attached");
        equal(true, lifecycle.initialized, "required delivery initializes component");
        equal(false, lifecycle.locked, "required delivery unlocks component");
        equal(1, ready, "ready callback called once");
        equal("unset", optionalValue, "optional dependency may remain absent");

        var optionalService = new TestUnknown();
        broker.provide(new AlternateIID(), optionalService);
        equal(optionalService, optionalValue, "optional dependency can arrive after initialization");
        equal(1, ready, "late optional delivery does not initialize twice");
        lifecycle.dispose();
        equal(true, lifecycle.disposed, "lifecycle disposed");
        equal(null, requiredValue, "dispose clears required setter");
        equal(null, optionalValue, "dispose clears optional setter");
        equal("ready", detached.join(","), "dependency event listener detached");
        equal(1, requiredService.releaseCalls, "required dependency released once");
        equal(1, optionalService.releaseCalls, "optional dependency released once");
        lifecycle.dispose();
        equal(1, requiredService.releaseCalls, "lifecycle disposal is idempotent");

        var lateBroker = new TestInterfaceBroker();
        var lateValue:Dynamic = null;
        var late = new ComponentDependencyLifecycle([
            new ComponentDependency(new MissingIID(), value -> lateValue = value)
        ], lateBroker.request, () -> {});
        late.dispose();
        var lateService = new TestUnknown();
        lateBroker.provide(new MissingIID(), lateService);
        equal(null, lateValue, "delivery after disposal is ignored");
        equal(1, lateService.releaseCalls, "ignored late delivery balances its acquired reference");
    }

    private static function testInterfaceBroker():Void {
        var broker = new ComponentInterfaceBroker();
        var calls:Array<String> = [];
        broker.queueInterface(new TestIID(), (_, _) -> calls.push("first"));
        broker.queueInterface(new TestIID(), (_, _) -> calls.push("second"));
        equal(1, broker.queuedInterfaceCount, "same IID shares one deferred queue");
        equal(0, broker.providerCount, "no provider before attach");

        var provider = new TestUnknown();
        broker.attach(provider, [new TestIID(), new AlternateIID()]);
        equal("first,second", calls.join(","), "deferred receivers run in registration order");
        equal(2, provider.queueCalls, "each deferred receiver acquires its own reference");
        equal(0, broker.queuedInterfaceCount, "fulfilled queue removed");
        equal(2, broker.providerCount, "provider exports both identifiers");

        var immediate:Dynamic = null;
        equal(provider, broker.queueInterface(new AlternateIID(), (_, value) -> immediate = value), "available interface returned");
        equal(provider, immediate, "available interface callback invoked");
        equal(3, provider.queueCalls, "immediate request acquires one reference");

        var lockedProvider = new TestUnknown();
        lockedProvider.available = false;
        var lockedValue:Dynamic = null;
        broker.queueInterface(new MissingIID(), (_, value) -> lockedValue = value);
        broker.attach(lockedProvider, [new MissingIID()], false);
        equal(null, lockedValue, "locked provider does not announce during attach");
        lockedProvider.available = true;
        broker.announceImplementor(lockedProvider);
        equal(lockedProvider, lockedValue, "unlock announces queued interface");

        equal(2, broker.detach(provider), "detach removes all provider interfaces");
        equal(null, broker.queueInterface(new TestIID()), "detached interface unavailable");
        equal(1, broker.providerCount, "other provider remains attached");
        equal(1, broker.detach(lockedProvider), "second provider detached");
        broker.dispose();
        equal(true, broker.disposed, "broker disposed");
        equal(false, provider.disposed, "broker disposal does not dispose provider");
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!same(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }

    private static inline function same(left:Dynamic, right:Dynamic):Bool {
        #if js
        return js.Syntax.strictEq(left, right);
        #else
        return left == right;
        #end
    }
}

private class TestIID implements IID {
    public function new() {}
}

private class AlternateIID implements IID {
    public function new() {}
}

private class MissingIID implements IID {
    public function new() {}
}

private class TestBootstrap {
    public function new() {}
}

private class TestUnknown implements IUnknown {
    public var disposed(get, never):Bool;
    private var _disposed = false;
    public var releaseCalls(default, null) = 0;
    public var queueCalls(default, null) = 0;
    public var available = true;

    public function new() {}

    private inline function get_disposed():Bool {
        return _disposed;
    }

    public function dispose():Void {
        _disposed = true;
    }

    public function queueInterface(identifier:IID, ?receiver:InterfaceReceiver):Null<IUnknown> {
        if (!available) {
            return null;
        }
        queueCalls++;
        if (receiver != null) {
            receiver(identifier, this);
        }
        return this;
    }

    public function release(identifier:IID):Int {
        releaseCalls++;
        return releaseCalls;
    }
}

private class TestInterfaceBroker {
    public var pendingCount(get, never):Int;
    private final pending:Array<{identifier:IID, receiver:InterfaceReceiver}> = [];

    public function new() {}

    private inline function get_pendingCount():Int {
        return pending.length;
    }

    public function request(identifier:IID, receiver:InterfaceReceiver):Null<IUnknown> {
        pending.push({identifier: identifier, receiver: receiver});
        return null;
    }

    public function provide(identifier:IID, unknown:IUnknown):Void {
        var name = ClassUtils.getQualifiedClassName(identifier);
        var matching:Array<{identifier:IID, receiver:InterfaceReceiver}> = [];
        var index = pending.length;
        while (index-- > 0) {
            if (ClassUtils.getQualifiedClassName(pending[index].identifier) == name) {
                matching.unshift(pending.splice(index, 1)[0]);
            }
        }
        for (item in matching) {
            item.receiver(item.identifier, unknown);
        }
    }
}
