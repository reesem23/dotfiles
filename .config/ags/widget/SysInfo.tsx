import { createPoll } from "ags/time"
import { execAsync } from "ags/process"

function Cpu() {
    const cpu = createPoll("0", 3000,
        ["bash", "-c", "top -bn1 | awk '/^%Cpu/{printf \"%.0f\", $2+$4}'"]
    )
    return (
        <label
            class="cpu"
            label={cpu.as(v => ` ${v.trim()}%`)}
            tooltipText={cpu.as(v => `CPU Usage: ${v.trim()}%`)}
        />
    )
}

function Mem() {
    const mem = createPoll("0", 3000,
        ["bash", "-c", "free | awk '/^Mem/{printf \"%.0f\", $3/$2*100}'"]
    )
    const memDetail = createPoll("", 3000,
        ["bash", "-c", "free -h | awk '/^Mem/{print $3\"/\"$2}'"]
    )
    return (
        <label
            class="mem"
            label={mem.as(v => ` ${v.trim()}%`)}
            tooltipText={memDetail.as(d => `Memory Used: ${d.trim()}`)}
        />
    )
}

function Volume() {
    const volRaw = createPoll("", 1000,
        ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
    )
    const label = volRaw.as(raw => {
        const muted = raw.includes("[MUTED]")
        const pct = Math.round(parseFloat(raw.split(" ")[1] ?? "0") * 100)
        return muted ? `󰖁 ${pct}%` : ` ${pct}%`
    })
    const tooltip = volRaw.as(raw => {
        const muted = raw.includes("[MUTED]")
        const pct = Math.round(parseFloat(raw.split(" ")[1] ?? "0") * 100)
        return `Volume: ${pct}% ${muted ? "(muted)" : ""} — click to toggle mute`
    })
    return (
        <button
            class="volume"
            label={label}
            tooltipText={tooltip}
            onClicked={() =>
                execAsync("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle").catch(console.error)
            }
        />
    )
}

function Battery() {
    const bat = createPoll("?", 10000,
        ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo '?'"]
    )
    const status = createPoll("Unknown", 10000,
        ["bash", "-c", "cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo 'Unknown'"]
    )
    const label = bat.as(v => {
        const pct = parseInt(v.trim())
        if (isNaN(pct)) return "? ?%"
        const icon = pct > 80 ? "" : pct > 50 ? "" : pct > 20 ? "" : ""
        return `${icon} ${pct}%`
    })
    const tooltip = status.as(s => {
        const st = s.trim()
        return `Battery: ${st === "Charging" ? "⚡ Charging" : st === "Discharging" ? "Discharging" : st}`
    })
    return (
        <label
            class="battery"
            label={label}
            tooltipText={tooltip}
        />
    )
}

function Network() {
    // Icon only in the bar — use a bash if/elif so no awk END-block bug
    const icon = createPoll("󰤭", 5000,
        ["bash", "-c",
            "if iwgetid -r &>/dev/null; then echo '󰤨';" +
            "elif nmcli -t -f TYPE,STATE dev 2>/dev/null | grep -q 'ethernet:connected'; then echo '󰈀';" +
            "else echo '󰤭'; fi"
        ]
    )
    // Tooltip: show the real SSID via iwgetid, or ethernet, or nothing
    const tip = createPoll("No connection", 5000,
        ["bash", "-c",
            "SSID=$(iwgetid -r 2>/dev/null);" +
            "if [ -n \"$SSID\" ]; then echo \"WiFi: $SSID\";" +
            "elif nmcli -t -f TYPE,STATE dev 2>/dev/null | grep -q 'ethernet:connected'; then echo 'Ethernet connected';" +
            "else echo 'No connection'; fi"
        ]
    )
    return (
        <button
            class="network"
            label={icon.as(v => v.trim())}
            tooltipText={tip.as(t => t.trim())}
            onClicked={() => execAsync("nm-connection-editor").catch(console.error)}
        />
    )
}

function Spotify() {
    return (
        <button
            class="shortcut spotify"
            label="󰓇"
            tooltipText="Open Spotify"
            onClicked={() => execAsync("spotify").catch(console.error)}
        />
    )
}

function LocalSend() {
    return (
        <button
            class="shortcut localsend"
            label="󰅢"
            tooltipText="Open LocalSend"
            onClicked={() => execAsync("localsend").catch(console.error)}
        />
    )
}

export default function SysInfo() {
    return (
        <box class="sysinfo" spacing={10}>
            <Spotify />
            <LocalSend />
            <Network />
            <Cpu />
            <Mem />
            <Volume />
            <Battery />
        </box>
    )
}
