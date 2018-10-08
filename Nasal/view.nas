#
#
#
# Project Tupolev for FlightGear
#
# Yurik V. Nikiforoff, yurik.nsk@gmail.com
# Novosibirsk, Russia
# mar 2008
#
# Custom views 
#

var modview_active = 0;


#	Modified by Yurik may 2013
#	Take from system FGDATA/Nasal/view.nas 
#	Add flag check for sub-view error fix.
#	

##
# Handler.  Step to the next (force=1) or next enabled view.
#
var stepView = func(step, force = 0) {
    if( modview_active ) return;	# Deny view modification if ~ pressed (sub view active)
    step = step > 0 ? 1 : -1;
    var n = index;
    for (var i = 0; i < size(views); i += 1) {
        n += step;
        if (n < 0)
            n = size(views) - 1;
        elsif (n >= size(views))
            n = 0;
        var e = views[n].getNode("enabled");
        if (force or (e == nil or e.getBoolValue()) and
            (views[n].getNode("name")!=nil))
            break;
    }
    setprop("/sim/current-view/view-number", n);

    # And pop up a nice reminder
    var popup=getprop("/sim/view-name-popup");
    if(popup == 1 or popup==nil) gui.popupTip(views[n].getNode("name").getValue());
}


var forceView = func{
	if( modview_active ) return;	# Deny view modification if ~ pressed (sub view active)
	var n = arg[0];
	# Hide levers on navigator view
	if( n == 2 ) setprop("an24/mod-views/nav-view", 1);
	else setprop("an24/mod-views/nav-view", 0);
	# Hide right yoke
	if( n == 1 ) setprop("an24/mod-views/copilot-view", 1);
	else setprop("an24/mod-views/copilot-view", 0);

	var offset = getprop("an24/mod-views/view-offset");
	if( n > 0 ) n = n + offset;
	setprop("sim/current-view/view-number", n);
	gui.popupTip(views[n].getNode("name").getValue());
};

#var modView  = func{
#	var n = getprop("sim/current-view/view-number");
#	var offset = getprop("an24/mod-views/view-offset");
#	if( n == nil ) n = 0;
#	if( n > 0 ) n = n - offset;
#	if( n < 0 ) return;
#	var mode = arg[0];
#	if( mode == nil ) mode = 0;
#	modview_active = mode;		# Set global ModView flag
#	# get mod view coordinates	
#	var mv = props.globals.getNode("an24/mod-views").getChildren("mod-view");
#	if( mode == 1 )
#	{
#	setprop("an24/mod-views/mod", 1 );
# save current position
#	setprop("an24/var/save-x", getprop("sim/current-view/x-offset-m") );
#	setprop("an24/var/save-y", getprop("sim/current-view/y-offset-m") );
#	setprop("an24/var/save-z", getprop("sim/current-view/z-offset-m") );
#	setprop("an24/var/save-fov", getprop("sim/current-view/field-of-view") );
#	setprop("an24/var/save-pitch", getprop("sim/current-view/pitch-offset-deg") );
#	setprop("an24/var/save-heading",getprop("sim/current-view/heading-offset-deg"));
#	setprop("an24/var/save-roll",getprop("sim/current-view/roll-offset-deg"));
# set modified view	
#	setprop("sim/current-view/x-offset-m", mv[n].getNode("x-offset-m").getValue() );
#	setprop("sim/current-view/y-offset-m", mv[n].getNode("y-offset-m").getValue() );
#	setprop("sim/current-view/z-offset-m", mv[n].getNode("z-offset-m").getValue() );
#	setprop("sim/current-view/field-of-view",
#		mv[n].getNode("field-of-view").getValue() );
#	setprop("sim/current-view/pitch-offset-deg", 
#		mv[n].getNode("pitch-offset-deg").getValue() );
#	setprop("sim/current-view/heading-offset-deg", 
#		mv[n].getNode("heading-offset-deg").getValue() );
#	setprop("sim/current-view/roll-offset-deg", 
#		mv[n].getNode("roll-offset-deg").getValue() );

#	return;
#	}
#	else
#	{
#	setprop("an24/mod-views/mod", 0 );
# save modified view	

#	mv[n].getNode("x-offset-m").setValue(getprop("sim/current-view/x-offset-m"));
#	mv[n].getNode("y-offset-m").setValue(getprop("sim/current-view/y-offset-m"));
#	mv[n].getNode("z-offset-m").setValue(getprop("sim/current-view/z-offset-m"));
# 	mv[n].getNode("field-of-view").setValue(
# 		getprop("sim/current-view/field-of-view"));
# 	mv[n].getNode("pitch-offset-deg").setValue(
# 		getprop("sim/current-view/pitch-offset-deg"));
# 	mv[n].getNode("heading-offset-deg").setValue(
# 		getprop("sim/current-view/heading-offset-deg"));
# 	mv[n].getNode("roll-offset-deg").setValue(
# 		getprop("sim/current-view/roll-offset-deg"));
				
#	setprop("sim/current-view/x-offset-m", getprop("an24/var/save-x") );
#	setprop("sim/current-view/y-offset-m", getprop("an24/var/save-y") );
#	setprop("sim/current-view/z-offset-m", getprop("an24/var/save-z") );
#	setprop("sim/current-view/field-of-view", getprop("an24/var/save-fov") );
#	setprop("sim/current-view/pitch-offset-deg", getprop("an24/var/save-pitch") );
#	setprop("sim/current-view/heading-offset-deg",getprop("an24/var/save-heading"));
#	setprop("sim/current-view/roll-offset-deg",getprop("an24/var/save-roll"));
#	}
#};

# Flight Engineer view

#var fe_view = {
#	start: func {
#		setprop("sim/current-view/config/heading-offset-deg", 
#			getprop("sim/view[104]/config/heading-offset-deg"));
#		},
#};


var init_offset = func{
setprop("/an24/mod-views/nav-view", 0);
setprop("/an24/mod-views/copilot-view", 0);
# Do we have Model View?
if( props.globals.getNode("/sim/view[7]") != nil )
  setprop("/an24/mod-views/view-offset", 7 );
else setprop("/an24/mod-views/view-offset", 6 );
}

init_offset();

#setlistener("/sim/signals/fdm-initialized", func {
#view.manager.register("Flight Engineer View", fe_view );});


# Added by Yurik jun 2013
# Load exterior at startup to avoid stale sim at first external view selection.
#var load_exterior = func{
#print("Load exterior, wait...");
# return to cabin to next cycle
#settimer( load_interior, 0 );
#setprop("/sim/current-view/view-number", 1);
#setprop("/sim/current-view/view-number", 8);
#}

#var load_interior = func{
#setprop("/sim/current-view/view-number", 0);
#print("Done!");
# Enable sim sound - it was disabled in instruments.nas while startup for avoid stupid effects sound.
#setprop("/sim/sound/volume", getprop("an24/volume") );
#}
# Start it late as we can
#setlistener("/sim/signals/fdm-initialized", load_exterior, 0, 0 );

#print("View registered");

