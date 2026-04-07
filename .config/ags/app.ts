import app from "ags/gtk3/app"
import GLib from "gi://GLib"
import Bar from "./widget/Bar"

const HOME = GLib.get_home_dir()

app.start({
    css: `${HOME}/.config/ags/style.css`,
    main() {
        app.get_monitors().map(Bar)
    },
})
