#!/usr/bin/env bash
set -euo pipefail

# Keep recorder state in the session runtime dir so stale state does not
# survive reboots or logouts.
state_dir="${XDG_RUNTIME_DIR:-/tmp}/niri-screen-recording"
pid_file="${state_dir}/wf-recorder.pid"
path_file="${state_dir}/output.path"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "ScreenRecorder" "$1" "${2:-}"
    fi
}

is_recording() {
    local pid

    if [[ ! -f "${pid_file}" ]]; then
        return 1
    fi

    pid="$(<"${pid_file}")"
    if kill -0 "${pid}" 2>/dev/null; then
        return 0
    fi

    rm -f "${pid_file}" "${path_file}"
    return 1
}

start_recording() {
    local output_file pid timestamp

    if is_recording; then
        notify "Screen recording already running" "$(cat "${path_file}" 2>/dev/null || true)"
        exit 0
    fi

    mkdir -p "${state_dir}" "${HOME}/Videos"

    timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
    output_file="${HOME}/Videos/screen-recording-${timestamp}.mp4"

    wf-recorder -f "${output_file}" >/dev/null 2>&1 < /dev/null &
    pid=$!

    sleep 0.2
    if ! kill -0 "${pid}" 2>/dev/null; then
        notify "Screen recording failed to start"
        exit 1
    fi

    printf '%s\n' "${pid}" > "${pid_file}"
    printf '%s\n' "${output_file}" > "${path_file}"

    notify "Screen recording started" "${output_file}"
}

stop_recording() {
    local output_file pid

    if ! is_recording; then
        notify "No screen recording is running"
        exit 0
    fi

    pid="$(<"${pid_file}")"
    output_file="$(cat "${path_file}" 2>/dev/null || true)"

    kill -INT "${pid}"
    for _ in {1..50}; do
        if ! kill -0 "${pid}" 2>/dev/null; then
            break
        fi
        sleep 0.1
    done

    rm -f "${pid_file}" "${path_file}"

    if [[ -n "${output_file}" ]]; then
        notify "Screen recording saved" "${output_file}"
    else
        notify "Screen recording stopped"
    fi
}

case "${1:-}" in
    start)
        start_recording
        ;;
    stop)
        stop_recording
        ;;
    *)
        printf 'Usage: %s {start|stop}\n' "$0" >&2
        exit 1
        ;;
esac
