import { Extension } from "resource:///org/gnome/shell/extensions/extension.js";
import Gio from "gi://Gio";
import { getInputSourceManager } from "resource:///org/gnome/shell/ui/status/keyboard.js";

const MR_DBUS_IFACE = `
<node>
	<interface name="org.gnome.Shell.Extensions.SwitchKeyboardLayout">
		<method name="Call">
			<arg type="u" direction="in" name="targetSource" />
		</method>
	</interface>
</node>
`;

export default class MyExtension extends Extension {
	enable() {
		this._dbus = Gio.DBusExportedObject.wrapJSObject(MR_DBUS_IFACE, this);
		this._dbus.export(Gio.DBus.session, '/org/gnome/Shell/Extensions/SwitchKeyboardLayout');
	}

	disable() {
		this._dbus.flush();
		this._dbus.unexport();
		delete this._dbus;
	}

	Call(targetSource) {
		getInputSourceManager().inputSources[targetSource].activate()
	}
}
