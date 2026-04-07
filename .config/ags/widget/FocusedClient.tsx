import { createPoll } from "ags/time"

export default function FocusedClient() {
    const title = createPoll("", 500,
        ["bash", "-c", "hyprctl activewindow -j 2>/dev/null | jq -r '.title // \"\"'"]
    )

    return (
        <label
            class="focused-client"
            label={title}
            tooltipText={title.as(t => t ? `Window: ${t}` : "No active window")}
            truncate
            maxWidthChars={50}
        />
    )
}
