import { createPoll } from "ags/time"
import GLib from "gi://GLib"

export default function Clock() {
    const time = createPoll("", 1000, () =>
        GLib.DateTime.new_now_local().format("%a %b %d %I:%M %p") ?? ""
    )

    const uptime = createPoll("", 60000,
        ["bash", "-c", "uptime -p | sed 's/^up //'"]
    )

    return (
        <label
            class="clock"
            label={time}
            tooltipText={uptime.as(u => `Uptime: ${u.trim()}`)}
        />
    )
}
