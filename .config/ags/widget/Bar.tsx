import app from "ags/gtk3/app"
import { Astal, Gtk, Gdk } from "ags/gtk3"
import Workspaces from "./Workspaces"
import FocusedClient from "./FocusedClient"
import Clock from "./Clock"
import SysInfo from "./SysInfo"

export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return (
        <window
            class="bar"
            gdkmonitor={monitor}
            application={app}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            layer={Astal.Layer.TOP}
            marginTop={8}
            marginLeft={40}
            marginRight={40}
        >
            <centerbox>
                <box $type="start" halign={Gtk.Align.START} spacing={8}>
                    <Workspaces />
                    <FocusedClient />
                </box>

                <box $type="center">
                    <Clock />
                </box>

                <box $type="end" halign={Gtk.Align.END} spacing={8}>
                    <SysInfo />
                </box>
            </centerbox>
        </window>
    )
}
