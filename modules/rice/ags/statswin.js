import {icon, gigabytes} from './utils.js'
import {battery} from './utils.js'
import {cpu, cpuspeed, ram} from './utils.js'

const getBatteryIcon = () => {
	if(battery.charging) return icon("battery-charging")
	return icon("battery")
}

const StatsWindow = (monitor = 0) => Widget.Window({
	name: `statswindow-${monitor}`,
	class_name: "statswindow",
	monitor: monitor,
	margins: [44, 0, 0, 0],
	anchor: ["top", "right"],
	exclusivity: "ignore",
	child: Widget.EventBox({
		child: Widget.Box({
			children: [
				Widget.CenterBox({
					vertical: true,
					start_widget: Widget.CenterBox({
						class_names: ["circularbox", "cpubox"],
						center_widget: Widget.CircularProgress({
							class_name: "big",
							child: Widget.Icon({
								icon: icon("cpu"),
								size: 20,
							}),
							value: cpu.bind(),
						}),
					}),
					center_widget: Widget.CenterBox({
						class_names: ["circularbox", "memorybox",],
						center_widget: Widget.CircularProgress({
							class_name: "big",
							child: Widget.Icon({
								icon: icon("ram"),
								size: 15,
							}),
							value: ram.bind().as(r => r[2] / r[1]),
						}),
					}),
					end_widget: Widget.CenterBox({
						class_names: ["circularbox", "batterybox"],
						center_widget: Widget.CircularProgress({
							class_name: "big",
							child: Widget.Icon({
								icon: Utils.watch(getBatteryIcon(), battery, getBatteryIcon),
								size: 30,
							}),
							value: battery.bind('percent').as(p => p > 0 ? p / 100 : 0),
						}),
					}),
				}),
				Widget.CenterBox({
					vertical: true,
					start_widget:  Widget.CenterBox({
						class_name: "statstextbox",
						vertical: true,
						start_widget: Widget.Label({ class_name: "cpulabel", label: "    cpu    " }),
						center_widget: Widget.Label({ class_name: "statlabel", label: cpu.bind().as(usage => `using ${Math.floor(usage*100)}%`) }),
						end_widget: Widget.Label({ class_name: "statlabel", label: cpuspeed.bind().as(freq => `${freq} Mhz`) }),
					}),
					center_widget: Widget.CenterBox({
						class_name: "statstextbox",
						vertical: true,
						start_widget: Widget.Label({ class_name: "ramlabel", label: "    ram    " }),
						center_widget: Widget.Label({ class_name: "statlabel", label: ram.bind().as(r => `using ${Math.floor(100*r[2]/r[1])}%`) }),
						end_widget: Widget.Label({ class_name: "statlabel", label: ram.bind().as(r => `${gigabytes(r[2])}/${gigabytes(r[1])}`) })
					}),
					end_widget: Widget.CenterBox({
						class_name: "statstextbox",
						vertical: true,
						start_widget: Widget.Label({ class_name: "batlabel", label: "  battery  " }),
						center_widget: Widget.Label({ class_name: "statlabel", label: battery.bind('percent').as(p => `currently at ${p}%`) }),
						end_widget: Widget.Label({ 
							class_name: "statlabel", 
							label: Utils.merge([battery.bind('charging'), battery.bind('time_remaining'), battery.bind('percent')], (status, t, percent) => {
								const min = Math.floor(t % 3600 / 60)
								const time = `${Math.floor(t/3600)}:${min > 9 ? min : `0${min}`}`
								if(percent == 100) return "battery full"
								return `${status == true ? `full in ${time}` : `dead in: ${time}`}`
							}) 
						}),
					}),
				})
			]
		})
	}),
})

export {StatsWindow};
