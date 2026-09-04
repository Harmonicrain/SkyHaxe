package com.sulake.core.window.utils;

import com.sulake.core.window.enums.WindowParam;
import haxe.ds.StringMap;

/**
 * Named layout params, ported from `com/sulake/core/window/utils/ParamCodeTable.as`.
 *
 * Application layouts carry params as a packed integer (`params="918545"`), but the internal skin
 * layouts spell them out:
 *
 *     <params><param name="relative_horizontal_scale_center" /></params>
 *
 * Both forms have to resolve to the same bits, or a control's internal children lay themselves out
 * differently from the window that hosts them.
 */
class ParamCodeTable {
	static var codes:Null<StringMap<Int>>;

	public static function code(name:String):Int {
		return table().exists(name) ? table().get(name) : WindowParam.NULL;
	}

	/** Fold a `<params>` element's `<param name="...">` children into one mask. */
	public static function mask(names:Array<String>):Int {
		var result = WindowParam.NULL;
		for (name in names) result |= code(name);
		return result;
	}

	static function table():StringMap<Int> {
		if (codes != null) return codes;
		var map = new StringMap<Int>();
		map.set("expand_to_accommodate_children", WindowParam.EXPAND_TO_ACCOMMODATE_CHILDREN);
		map.set("resize_to_accommodate_children", WindowParam.RESIZE_TO_ACCOMMODATE_CHILDREN);
		map.set("input_event_processor", WindowParam.INPUT_EVENT_PROCESSOR);
		map.set("internal_event_handling", WindowParam.INTERNAL_EVENT_HANDLING);
		map.set("observe_parent_input_events", WindowParam.OBSERVE_PARENT_INPUT_EVENTS);
		map.set("route_input_events_to_parent", WindowParam.ROUTE_INPUT_EVENTS_TO_PARENT);
		map.set("use_parent_graphic_context", WindowParam.USE_PARENT_GRAPHIC_CONTEXT);
		map.set("bound_to_parent_rect", WindowParam.BOUND_TO_PARENT_RECT);
		map.set("parent_window", WindowParam.PARENT_WINDOW);

		map.set("mouse_dragging_target", WindowParam.MOUSE_DRAGGING_TARGET);
		map.set("mouse_dragging_trigger", WindowParam.MOUSE_DRAGGING_TRIGGER);
		map.set("draggable_with_mouse", WindowParam.DRAGGABLE_WITH_MOUSE);
		map.set("mouse_scaling_target", WindowParam.MOUSE_SCALING_TARGET);
		map.set("mouse_scaling_trigger", WindowParam.MOUSE_SCALING_TRIGGER);
		map.set("horizontal_mouse_scaling_trigger", WindowParam.HORIZONTAL_MOUSE_SCALING_TRIGGER);
		map.set("vertical_mouse_scaling_trigger", WindowParam.VERTICAL_MOUSE_SCALING_TRIGGER);
		map.set("scalable_with_mouse", WindowParam.SCALABLE_WITH_MOUSE);

		// "strech" is the client's spelling. Kept as-is: it is the key in the shipped data.
		map.set("relative_horizontal_scale_fixed", WindowParam.RELATIVE_HORIZONTAL_SCALE_FIXED);
		map.set("relative_horizontal_scale_move", WindowParam.RELATIVE_HORIZONTAL_SCALE_MOVE);
		map.set("relative_horizontal_scale_strech", WindowParam.RELATIVE_HORIZONTAL_SCALE_STRETCH);
		map.set("relative_horizontal_scale_center", WindowParam.RELATIVE_HORIZONTAL_SCALE_CENTER);
		map.set("relative_vertical_scale_fixed", WindowParam.RELATIVE_VERTICAL_SCALE_FIXED);
		map.set("relative_vertical_scale_move", WindowParam.RELATIVE_VERTICAL_SCALE_MOVE);
		map.set("relative_vertical_scale_strech", WindowParam.RELATIVE_VERTICAL_SCALE_STRETCH);
		map.set("relative_vertical_scale_center", WindowParam.RELATIVE_VERTICAL_SCALE_CENTER);
		map.set("relative_scale_fixed", WindowParam.RELATIVE_SCALE_FIXED);
		map.set("relative_scale_move", WindowParam.RELATIVE_SCALE_MOVE);
		map.set("relative_scale_strech", WindowParam.RELATIVE_SCALE_STRETCH);
		map.set("relative_scale_center", WindowParam.RELATIVE_SCALE_CENTER);

		map.set("on_resize_align_left", WindowParam.ON_RESIZE_ALIGN_LEFT);
		map.set("on_resize_align_right", WindowParam.ON_RESIZE_ALIGN_RIGHT);
		map.set("on_resize_align_center", WindowParam.ON_RESIZE_ALIGN_CENTER);
		map.set("on_resize_align_top", WindowParam.ON_RESIZE_ALIGN_TOP);
		map.set("on_resize_align_bottom", WindowParam.ON_RESIZE_ALIGN_BOTTOM);
		map.set("on_resize_align_middle", WindowParam.ON_RESIZE_ALIGN_MIDDLE);
		map.set("on_accommodate_align_left", WindowParam.ON_ACCOMMODATE_ALIGN_LEFT);
		map.set("on_accommodate_align_right", WindowParam.ON_ACCOMMODATE_ALIGN_RIGHT);
		map.set("on_accommodate_align_center", WindowParam.ON_ACCOMMODATE_ALIGN_CENTER);
		map.set("on_accommodate_align_top", WindowParam.ON_ACCOMMODATE_ALIGN_TOP);
		map.set("on_accommodate_align_bottom", WindowParam.ON_ACCOMMODATE_ALIGN_BOTTOM);
		map.set("on_accommodate_align_middle", WindowParam.ON_ACCOMMODATE_ALIGN_MIDDLE);

		map.set("reflect_horizontal_resize_to_parent",
			WindowParam.REFLECT_HORIZONTAL_RESIZE_TO_PARENT);
		map.set("reflect_vertical_resize_to_parent",
			WindowParam.REFLECT_VERTICAL_RESIZE_TO_PARENT);
		map.set("reflect_resize_to_parent", WindowParam.REFLECT_RESIZE_TO_PARENT);
		map.set("force_clipping", WindowParam.FORCE_CLIPPING);
		map.set("inherit_caption", WindowParam.INHERIT_CAPTION);
		codes = map;
		return map;
	}
}
