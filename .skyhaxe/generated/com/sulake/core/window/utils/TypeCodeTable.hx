package com.sulake.core.window.utils
;
    import com.sulake.core.window._enum.WindowType;

     class TypeCodeTable extends WindowType 
    {
        public static function fillTables(dict:ASDictionary<ASAny,ASAny>, addTo:ASDictionary<ASAny,ASAny>=null)
        {
var key:String  = null;            dict["background"] = WindowType.WINDOW_TYPE_BACKGROUND;
            dict["bitmap"] = WindowType.WINDOW_TYPE_BITMAP_WRAPPER;
            dict["shape"] = WindowType.WINDOW_TYPE_SHAPE_WRAPPER;
            dict["border"] = WindowType.WINDOW_TYPE_BORDER;
            dict["boxsizer"] = WindowType.WINDOW_TYPE_BOXSIZER;
            dict["border_notify"] = WindowType.WINDOW_TYPE_BORDER_NOTIFY;
            dict["bubble"] = WindowType.WINDOW_TYPE_BUBBLE;
            dict["bubble_pointer_up"] = WindowType.WINDOW_TYPE_BUBBLE_POINTER_UP;
            dict["bubble_pointer_right"] = WindowType.WINDOW_TYPE_BUBBLE_POINTER_RIGHT;
            dict["bubble_pointer_down"] = WindowType.WINDOW_TYPE_BUBBLE_POINTER_DOWN;
            dict["bubble_pointer_left"] = WindowType.WINDOW_TYPE_BUBBLE_POINTER_LEFT;
            dict["button"] = WindowType.WINDOW_TYPE_BUTTON;
            dict["button_thick"] = WindowType.WINDOW_TYPE_BUTTON_THICK;
            dict["button_icon"] = WindowType.WINDOW_TYPE_BUTTON_ICON;
            dict["button_group_left"] = WindowType.WINDOW_TYPE_BUTTON_GROUP_LEFT;
            dict["button_group_center"] = WindowType.WINDOW_TYPE_BUTTON_GROUP_CENTER;
            dict["button_group_right"] = WindowType.WINDOW_TYPE_BUTTON_GROUP_RIGHT;
            dict["checkbox"] = WindowType.WINDOW_TYPE_CHECKBOX;
            dict["closebutton"] = WindowType.WINDOW_TYPE_CLOSEBUTTON;
            dict["container"] = WindowType.WINDOW_TYPE_CONTAINER;
            dict["container_button"] = WindowType.WINDOW_TYPE_CONTAINER_BUTTON;
            dict["display_object_wrapper"] = WindowType.WINDOW_TYPE_DISPLAY_OBJECT_WRAPPER;
            dict["dropmenu"] = WindowType.WINDOW_TYPE_DROPMENU;
            dict["dropmenu_item"] = WindowType.WINDOW_TYPE_DROPMENU_ITEM;
            dict["droplist"] = WindowType.WINDOW_TYPE_DROPLIST;
            dict["droplist_item"] = WindowType.WINDOW_TYPE_DROPLIST_ITEM;
            dict["formatted_text"] = WindowType.WINDOW_TYPE_FORMATTED_TEXT;
            dict["frame"] = WindowType.WINDOW_TYPE_FRAME;
            dict["frame_notify"] = WindowType.WINDOW_TYPE_FRAME_NOTIFY;
            dict["gradient"] = WindowType.WINDOW_TYPE_GRADIENT;
            dict["header"] = WindowType.WINDOW_TYPE_HEADER;
            dict["html"] = WindowType.WINDOW_TYPE_HTML;
            dict["icon"] = WindowType.WINDOW_TYPE_ICON;
            dict["itemgrid"] = WindowType.WINDOW_TYPE_ITEMGRID;
            dict["itemgrid_horizontal"] = WindowType.WINDOW_TYPE_ITEMGRID_HORIZONTAL;
            dict["itemgrid_vertical"] = WindowType.WINDOW_TYPE_ITEMGRID_VERTICAL;
            dict["itemlist"] = WindowType.WINDOW_TYPE_ITEMLIST;
            dict["itemlist_horizontal"] = WindowType.WINDOW_TYPE_ITEMLIST_HORIZONTAL;
            dict["itemlist_vertical"] = WindowType.WINDOW_TYPE_ITEMLIST_VERTICAL;
            dict["label"] = WindowType.WINDOW_TYPE_LABEL;
            dict["maximizebox"] = WindowType.WINDOW_TYPE_MAXIMIZEBOX;
            dict["menu"] = WindowType.WINDOW_TYPE_MENU;
            dict["menu_item"] = WindowType.WINDOW_TYPE_MENU_ITEM;
            dict["submenu"] = WindowType.WINDOW_TYPE_SUBMENU;
            dict["minimizebox"] = WindowType.WINDOW_TYPE_MINIMIZEBOX;
            dict["notify"] = WindowType.WINDOW_TYPE_NOTIFY;
            dict["null"] = WindowType.WINDOW_TYPE_NULL;
            dict["password"] = WindowType.WINDOW_TYPE_PASSWORD;
            dict["radiobutton"] = WindowType.WINDOW_TYPE_RADIOBUTTON;
            dict["region"] = WindowType.WINDOW_TYPE_REGION;
            dict["restorebox"] = WindowType.WINDOW_TYPE_RESTOREBOX;
            dict["scaler"] = WindowType.WINDOW_TYPE_SCALER;
            dict["scaler_horizontal"] = WindowType.WINDOW_TYPE_SCALER_HORIZONTAL;
            dict["scaler_vertical"] = WindowType.WINDOW_TYPE_SCALER_VERTICAL;
            dict["scrollbar_horizontal"] = WindowType.WINDOW_TYPE_SCROLLBAR_HORIZONTAL;
            dict["scrollbar_vertical"] = WindowType.WINDOW_TYPE_SCROLLBAR_VERTICAL;
            dict["scrollbar_slider_button_up"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_BUTTON_UP;
            dict["scrollbar_slider_button_down"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_BUTTON_DOWN;
            dict["scrollbar_slider_button_left"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_BUTTON_LEFT;
            dict["scrollbar_slider_button_right"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_BUTTON_RIGHT;
            dict["scrollbar_slider_bar_horizontal"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_BAR_HORIZONTAL;
            dict["scrollbar_slider_bar_vertical"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_BAR_VERTICAL;
            dict["scrollbar_slider_track_horizontal"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_TRACK_HORIZONTAL;
            dict["scrollbar_slider_track_vertical"] = WindowType.WINDOW_TYPE_SCROLLBAR_SLIDER_TRACK_VERTICAL;
            dict["scrollable_itemlist"] = WindowType.WINDOW_TYPE_SCROLLABLE_ITEMLIST;
            dict["scrollable_itemlist_vertical"] = WindowType.WINDOW_TYPE_SCROLLABLE_ITEMLIST_VERTICAL;
            dict["scrollable_itemgrid_vertical"] = WindowType.WINDOW_TYPE_SCROLLABLE_ITEMGRID_VERTICAL;
            dict["scrollable_itemlist_horizontal"] = WindowType.WINDOW_TYPE_SCROLLABLE_ITEMLIST_HORIZONTAL;
            dict["selector"] = WindowType.WINDOW_TYPE_SELECTOR;
            dict["selector_list"] = WindowType.WINDOW_TYPE_SELECTOR_LIST;
            dict["static_bitmap"] = WindowType.WINDOW_TYPE_STATIC_BITMAP_WRAPPER;
            dict["tab_button"] = WindowType.WINDOW_TYPE_TAB_BUTTON;
            dict["tab_container_button"] = WindowType.WINDOW_TYPE_TAB_CONTAINER_BUTTON;
            dict["tab_context"] = WindowType.WINDOW_TYPE_TAB_CONTEXT;
            dict["tab_content"] = WindowType.WINDOW_TYPE_TAB_CONTENT;
            dict["tab_selector"] = WindowType.WINDOW_TYPE_TAB_SELECTOR;
            dict["text"] = WindowType.WINDOW_TYPE_TEXT;
            dict["input"] = WindowType.WINDOW_TYPE_TEXTFIELD;
            dict["link"] = WindowType.WINDOW_TYPE_LINK;
            dict["toolbar"] = WindowType.WINDOW_TYPE_TOOLBAR;
            dict["tooltip"] = WindowType.WINDOW_TYPE_TOOLTIP;
            dict["widget"] = WindowType.WINDOW_TYPE_WIDGET;
            if (addTo != null)
            {
                if (checkNullIteratee(dict)) for (_tmp_ in dict.keys())
                {
key = _tmp_;
                    addTo[dict[key]] = key;
                }
            }
        }

	public function new() { super(); }
    }

