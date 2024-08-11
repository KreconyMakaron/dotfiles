import {revealBox, circular, icon} from './utils.js'
import {hyprland, battery, audio, network} from './utils.js'
import {cpu, ram} from './utils.js'
import brightness from './utils.js'
import {StatsWindow} from './statswin.js'

const getBrightnessIcon = () => {
	if(brightness.screen_value < 0.3) return icon("brightness-low")
	if(brightness.screen_value < 0.6) return icon("brightness-half")
	return icon("brightness-high")
}

const getVolumeIcon = () => {
	if(audio.speaker.is_muted) return icon('volume-x');
	else if(audio.speaker.volume < 0.3) return icon('volume');
	else if(audio.speaker.volume < 0.6) return icon('volume-1');
	else return icon('volume-2');
}

const getNetworkIcon = () => {
	if(network.primary == 'wired') return icon('ethernet')

	if(network.primary == 'wifi') {
		if(network.wifi.ssid == '') return icon('wifi-off')
		else return icon('wifi')
	}
	else return icon('wifi-off')
}

const Workspaces = () => {
	const min_workspace_count = 6;

	const active_workspace = icon("circle-full")
	const full_workspace = icon("circle-empty")
	const empty_workspace = icon("circle-empty-gray")

	const activeWorkspace = hyprland.active.workspace.bind("id")

	const workspaces = hyprland.bind("workspaces").as(ws => {
		const ids = ws.map(({ id }) => Number(id))
		let work = []

		const label = (work = 0) => Widget.Icon({
			class_name: activeWorkspace.as(i => `${ i === work ? "activeworkspace" : (ids.includes(work) ? "fullworkspace" : "emptyworkspace") }`),
			icon: activeWorkspace.as(i => `${ i === work ? active_workspace : (ids.includes(work) ? full_workspace : empty_workspace) }`)
		})

		for(let id = 1; id <= min_workspace_count; id++) {
			work.push(Widget.Button({
				on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
				child: label(id)
			}))
		}

		for(let id = min_workspace_count+1; id <= 10; id++) {
			if(!ids.includes(id)) continue
			work.push(Widget.Button({
				on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
				child: label(id)
			}))
		}

		return work
	})

	return Widget.Box({
		class_name: "workspaces",
		children: workspaces,
	})
}

const Stats = (statswindow) => {
	const Processor = Widget.Box({
		class_name: "cpubox",
		child: circular(
			cpu.bind(),
			cpu.bind().as(usage => `using ${Math.floor(100*usage)}% cpu`)
		),
	})

	const Memory = Widget.Box({
		class_name: "memorybox",
		child: circular(
			ram.bind().as(r => r[2] / r[1]),
			ram.bind().as(r => `using ${Math.floor(100*r[2]/r[1])}% ram`)
		),
	})

	const Battery = Widget.Box({
		class_name: "batterybox",
		child: circular(
			battery.bind('percent').as(p => p > 0 ? p / 100 : 0), 
			battery.bind('percent').as(percent => `battery at ${percent}%`) 
		),
	})

	return Widget.Button({
		class_name: "statbox",
		child: Widget.CenterBox({
			startWidget: Processor,
			centerWidget: Memory,
			endWidget: Battery,
		}),
		on_clicked: () => statswindow.visible ? statswindow.hide() : statswindow.show()
	})
}

const Clock = (calendar) => {
	const date = Variable([], { 
		poll: [1000, 'date "+%H:%M:%S %d.%m"', out => out.split(/\s+/)], 
	})
    return revealBox(
		Widget.Label({
			class_name: "clock",
			label: date.bind().as(d => d[0]),
		}),
		Widget.Button({
			class_name: "date",
			label: date.bind().as(d => ` ${d[1]}`),
			on_clicked: () => calendar.visible ? calendar.hide() : calendar.show()
		}),
		"slide_right",
		"clockbox"
	)
}

const Volume = () => revealBox(
	Widget.Button({
		child: Widget.Icon({
			icon: Utils.watch(getVolumeIcon(), audio, getVolumeIcon),
			size: 20,
		}),	
		class_name: "iconbutton",
		on_clicked: () => audio.speaker.is_muted = !audio.speaker.is_muted,
	}),
	Widget.Box({
		class_name: "sliderbox",
		child: Widget.Slider({
			hexpand: true,
			draw_value: false,
			on_change: ({ value }) => audio['speaker'].volume = value,
			value: audio['speaker'].bind('volume'),
		}),
		tooltip_text: audio['speaker'].bind('volume').as(vol => `volume at ${Math.floor(vol*100)}%`)
	}),
	"slide_right",
	"volumebox"
)

const Network = () => revealBox(
	Widget.Button({
		class_name: "iconbutton",
		child: Widget.Icon({
			icon: Utils.watch(getNetworkIcon(), network, getNetworkIcon),
			size: 20,
		})
	}),
	Widget.Label({ label: network.wifi.bind('ssid') .as(ssid => ` ${ssid || 'Unknown'}`) }),
	"slide_right",
	"networkbox"
)


const Backlight = () => revealBox(
	Widget.Button({
		class_name: "iconbutton",
		child: Widget.Icon({
			icon: Utils.watch(getBrightnessIcon(), brightness, getBrightnessIcon),
			size: 20,
		}),
	}),
	Widget.Box({
		class_name: "sliderbox",
		child: Widget.Slider({
			hexpand: true,
			draw_value: false,
			on_change: self => brightness.screen_value = self.value,
			// @ts-ignore
			value: brightness.bind('screen-value'),
		}),
		tooltip_text: brightness.bind('screen_value').as(b => `brightness at ${Math.floor(100*b)}%`)
	}),
	"slide_right",
	"brightnessbox"
)

const CalendarWindow = () => Widget.Window({
	name: "calendarwindow",
	class_name: "calendarwindow",
	margins: [42, 0, 0, 0],
	anchor: ["top", "right"],
	exclusivity: "ignore",
	child: Widget.Box({
		child: Widget.Calendar({
			showDayNames: false,
			showDetails: true,
			showHeading: true,
			showWeekNumbers: true,
			detail: () => {
				return `<span color="white">         </span>`
			},
		}),
	}),
})

const Bar = (monitor = 0) => {
	const calendar = CalendarWindow()
	const statswindow = StatsWindow(monitor)

	calendar.hide();
	statswindow.hide()

	return Widget.Window({
		name: `bar-${monitor}`,
		class_name: "bar",
		monitor: monitor,
		anchor: ["top", "left", "right"],
		exclusivity: "exclusive",
		child: Widget.CenterBox({
			start_widget: Widget.Box({
				spacing: 8,
				children: [
					Workspaces()
				],
			}),
			end_widget: Widget.Box({
				hpack: "end",
				spacing: 8,
				children: [
					Network(),
					Backlight(),
					Volume(),
					Stats(statswindow),
					Clock(calendar)
				],
			}),
		}),
	})
}

export {Bar}
