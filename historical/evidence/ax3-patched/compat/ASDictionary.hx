#if flash
private typedef Dictionary<K,V> = flash.utils.Dictionary;
#else
private typedef Dictionary<K,V> = ASDictionaryData<K,V>;
#end

abstract ASDictionary<K,V>(Dictionary<K,V>) from Dictionary<K,V> to Dictionary<K,V> {
	public extern inline function new(weakKeys : Bool = false) {
		this = new Dictionary<K,V>(weakKeys);
	}

	@:op([]) public inline function get(key:K):Null<V> {
		#if flash
		return untyped this[key];
		#else
		return this.get(key);
		#end
	}

	@:op([]) public inline function set(key:K, value:V):Null<V> {
		#if flash
		return untyped this[key] = value;
		#else
		return this.set(key, value);
		#end
	}

	public inline function exists(key:K):Bool {
		#if flash
		return untyped __in__(key, this);
		#else
		return this.exists(key);
		#end
	}

	public inline function remove(key:K):Bool {
		#if flash
		return untyped __delete__(this, key);
		#else
		return this.remove(key);
		#end
	}

	public inline function keys() {
		#if flash
		return new NativePropertyIterator<K>(this);
		#else
		return this.iterator();
		#end
	}

	public inline function iterator() {
		#if flash
		return new NativeValueIterator<V>(this);
		#else
		return this.each();
		#end
	}

	public inline function keyValueIterator() {
		#if flash
		return new NativePropertyValueIterator<K,V>(this);
		#else
		return this.keyValueIterator();
		#end
	}

	public static inline function asDictionary<K,V>(v:Any):Null<Dictionary<K,V>> {
		#if flash
		return flash.Lib.as(v, flash.utils.Dictionary);
		#else
		return Std.isOfType(v, ASDictionaryData) ? cast v : null;
		#end
	}

	public static final type = #if flash flash.utils.Dictionary #else ASDictionaryData #end;
}

#if !flash
/**
 * Flash Dictionary accepts primitive and object keys in the same instance. OpenFL's Dictionary
 * selects an ObjectMap for ASAny, which crashes when a string key is inserted. The avatar data
 * uses both forms, so retain AS3 identity/equality semantics with a small mixed-key table.
 */
private class ASDictionaryData<K,V> {
	final entries:Array<{key:K, value:V}> = [];
	final strings = new haxe.ds.StringMap<{key:K, value:V}>();

	public function new(weakKeys:Bool = false) {}

	/**
		Flash stores a Dictionary's non-object keys the way an Object stores property names, so
		`d[10]` and `d["10"]` are one slot; only object keys compare by identity.

		The client depends on this. `Map` is a Proxy: `setProperty` writes its table under the key
		it was given -- `HabboMessages` registers all 601 message ids as ints -- while `nextName` is
		declared `:String`, so AS3 coerces every key a `for..in` yields to its string form. The
		original `MessageClassManager.registerMessages` reads each event class back with that
		string, which only finds anything because Flash normalises the two to one slot.

		Returns null for object keys, which keep the identity comparison.
	**/
	static inline function propertyKey(key:Dynamic):Null<String> {
		var kind = js.Syntax.typeof(key);
		return (kind == "string" || kind == "number" || kind == "boolean") ? Std.string(key) : null;
	}

	public function get(key:K):Null<V> {
		if (Std.isOfType(key, String)) {
			var entry = strings.get(cast key);
			return entry == null ? js.Syntax.code("undefined") : entry.value;
		}
		var name = propertyKey(key);
		if (name != null) {
			var entry = strings.get(name);
			return entry == null ? js.Syntax.code("undefined") : entry.value;
		}
		for (entry in entries) if (js.Syntax.code("{0} === {1}", entry.key, key)) return entry.value;
		// Flash Dictionary returns `undefined` for an absent key. This distinction is observable:
		// Number(undefined) is NaN, while Number(null) is 0. RoomObjectModel relies on the former
		// when deciding whether FURNITURE_AUTOMATIC_STATE_INDEX exists; returning null made every
		// animated furniture visualization overwrite its packet state with animation zero.
		return js.Syntax.code("undefined");
	}

	public function set(key:K, value:V):V {
		if (Std.isOfType(key, String)) {
			var entry = strings.get(cast key);
			if (entry == null) {
				entry = {key:key, value:value};
				strings.set(cast key, entry);
				entries.push(entry);
			} else entry.value = value;
			return value;
		}
		var name = propertyKey(key);
		if (name != null) {
			var entry = strings.get(name);
			if (entry == null) {
				entry = {key:key, value:value};
				strings.set(name, entry);
				entries.push(entry);
			} else entry.value = value;
			return value;
		}
		for (entry in entries) if (js.Syntax.code("{0} === {1}", entry.key, key)) {
			entry.value = value;
			return value;
		}
		entries.push({key: key, value: value});
		return value;
	}

	public function exists(key:K):Bool {
		if (Std.isOfType(key, String)) return strings.exists(cast key);
		var name = propertyKey(key);
		if (name != null) return strings.exists(name);
		for (entry in entries) if (js.Syntax.code("{0} === {1}", entry.key, key)) return true;
		return false;
	}

	public function remove(key:K):Bool {
		// Primitive-key removal reads the entry before deleting its lookup slot.
		var name = propertyKey(key);
		if (name != null) {
			// Removed by reference: the entry still carries the key as first written, which for a
			// normalised key is not identical to the one it is being removed under.
			var entry = strings.get(name);
			if (entry == null) return false;
			strings.remove(name);
			entries.remove(entry);
			return true;
		}
		for (index in 0...entries.length) if (js.Syntax.code("{0} === {1}", entries[index].key, key)) {
			entries.splice(index, 1);
			return true;
		}
		return false;
	}

	public function iterator():Iterator<K>
		return [for (entry in entries) entry.key].iterator();

	public function each():Iterator<V>
		return [for (entry in entries) entry.value].iterator();

	public function keyValueIterator():KeyValueIterator<K,V> {
		var copy = entries.copy();
		var index = 0;
		return {
			hasNext: function() return index < copy.length,
			next: function() {
				var entry = copy[index++];
				return {key: entry.key, value: entry.value};
			}
		};
	}
}
#end
