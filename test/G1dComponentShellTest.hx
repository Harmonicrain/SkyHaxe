import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.runtime.Component;
import com.sulake.core.runtime.ComponentContext;
import com.sulake.core.runtime.ComponentDependency;
import com.sulake.core.runtime.IID;
import com.sulake.core.runtime.IUnknown;
import openfl.events.Event;

class G1dComponentShellTest {
    public static var assertions(default, null):Int = 0;

    public static function main():Void {
        testContextAndImmediateDependency();
        testDeferredUnlockAndDisposal();
        trace('G1D_COMPONENT_SHELL_PASS assertions=$assertions');
    }

    private static function testContextAndImmediateDependency():Void {
        var libraryBaseline = AssetLibrary.numAssetLibraryInstances;
        var context = new ComponentContext();
        equal(context, context.root, "root context resolves itself");
        var service = new ServiceComponent(context);
        context.attachComponent(service, [new ServiceIID()]);
        equal(service, context.queueInterface(new ServiceIID()), "context routes attached service");
        equal(0, service.release(new ServiceIID()), "manual request releases back to zero");

        var consumer = new ConsumerComponent(context);
        equal(true, consumer.initialized, "immediate dependency initializes in constructor");
        equal(service, consumer.service, "immediate dependency injected");
        equal(false, consumer.locked, "immediate dependency unlocks consumer");
        context.attachComponent(consumer, [new ConsumerIID()]);
        equal(1, service.references, "consumer holds one service reference");
        consumer.dispose();
        equal(0, service.references, "consumer disposal releases dependency");
        equal(null, consumer.service, "consumer disposal clears setter");
        context.dispose();
        equal(true, service.disposed, "context disposes attached service");
        equal(libraryBaseline, AssetLibrary.numAssetLibraryInstances, "component assets fully disposed");
    }

    private static function testDeferredUnlockAndDisposal():Void {
        var context = new ComponentContext();
        var consumer = new ConsumerComponent(context);
        context.attachComponent(consumer, [new ConsumerIID()]);
        equal(true, consumer.locked, "missing required dependency locks consumer");
        equal(false, consumer.initialized, "missing dependency delays initialization");
        equal(null, context.queueInterface(new ConsumerIID()), "locked consumer does not announce interface");

        var runningEvents = 0;
        consumer.events.addEventListener(Component.COMPONENT_EVENT_RUNNING, _ -> runningEvents++);
        var service = new ServiceComponent(context);
        context.attachComponent(service, [new ServiceIID()]);
        equal(true, consumer.initialized, "deferred dependency initializes consumer");
        equal(false, consumer.locked, "deferred dependency unlocks consumer");
        equal(service, consumer.service, "deferred service injected");
        equal(1, runningEvents, "running event dispatched once");
        equal(consumer, context.queueInterface(new ConsumerIID()), "unlocked consumer interface announced");
        equal(0, consumer.release(new ConsumerIID()), "consumer interface released");

        var ephemeral = new ServiceComponent(context, Component.COMPONENT_FLAG_INTERFACE);
        context.attachComponent(ephemeral, [new EphemeralIID()]);
        equal(ephemeral, context.queueInterface(new EphemeralIID()), "ephemeral interface acquired");
        equal(0, ephemeral.release(new EphemeralIID()), "ephemeral final release");
        equal(true, ephemeral.disposed, "interface component auto-disposes at zero references");
        equal(null, context.queueInterface(new EphemeralIID()), "auto-disposed interface detached");

        var lateConsumer = new LateConsumerComponent(context);
        context.attachComponent(lateConsumer, []);
        lateConsumer.dispose();
        var lateService = new ServiceComponent(context);
        context.attachComponent(lateService, [new LateIID()]);
        equal(0, lateService.references, "disposed waiter balances late dependency acquisition");
        context.dispose();
        equal(true, consumer.disposed, "context disposes deferred consumer");
        equal(true, service.disposed, "context disposes deferred service");
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!js.Syntax.strictEq(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }
}

private class ServiceIID implements IID { public function new() {} }
private class ConsumerIID implements IID { public function new() {} }
private class EphemeralIID implements IID { public function new() {} }
private class LateIID implements IID { public function new() {} }

private class ServiceComponent extends Component {
    public var references(get, never):Int;
    private var _references = 0;

    public function new(context:ComponentContext, flags:Int = 0) {
        super(context, flags);
    }

    override public function queueInterface(identifier:IID, ?receiver:com.sulake.core.runtime.IUnknown.InterfaceReceiver):Null<IUnknown> {
        var result = super.queueInterface(identifier, receiver);
        if (result != null) _references++;
        return result;
    }

    override public function release(identifier:IID):Int {
        if (_references > 0) _references--;
        super.release(identifier);
        return _references;
    }

    private inline function get_references():Int return _references;
}

private class ConsumerComponent extends Component {
    public var service(default, null):Null<ServiceComponent>;
    public var initialized(default, null) = false;

    public function new(context:ComponentContext) {
        super(context);
    }

    override public function getDependencies():Array<ComponentDependency> {
        return [new ComponentDependency(new ServiceIID(), value -> service = cast value)];
    }

    override public function initComponent():Void {
        initialized = true;
    }
}

private class LateConsumerComponent extends Component {
    public function new(context:ComponentContext) {
        super(context);
    }

    override public function getDependencies():Array<ComponentDependency> {
        return [new ComponentDependency(new LateIID(), _ -> {})];
    }
}
