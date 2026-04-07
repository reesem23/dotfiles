import { createPoll } from "ags/time"
import { execAsync } from "ags/process"

export default function Workspaces() {
    const activeId = createPoll(1, 300,
        ["bash", "-c", "hyprctl activeworkspace -j 2>/dev/null | jq '.id // 1'"],
        (out) => parseInt(out.trim()) || 1
    )

    return (
        <box class="workspaces" spacing={4}>
            {[1, 2, 3, 4, 5, 6].map(id => (
                <button
                    class={activeId.as(a => `workspace${a === id ? " focused" : ""}`)}
                    tooltipText={`Workspace ${id}`}
                    onClicked={() => execAsync(`hyprctl dispatch workspace ${id}`).catch(console.error)}
                >
                    {String(id)}
                </button>
            ))}
        </box>
    )
}
