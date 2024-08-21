import {icon} from './utils.js'
const { query } = await Service.import("applications")

const lavenstein = (s1, s2) => {
	var row2 = [];
	if (s1 === s2) {
		return 0;
	} else {
		var s1_len = s1.length, s2_len = s2.length;
		if (s1_len && s2_len) {
			var i1 = 0, i2 = 0, a, b, c, c2, row = row2;
			while (i1 < s1_len)
				row[i1] = ++i1;
			while (i2 < s2_len) {
				c2 = s2.charCodeAt(i2);
				a = i2;
				++i2;
				b = i2;
				for (i1 = 0; i1 < s1_len; ++i1) {
					c = a + (s1.charCodeAt(i1) === c2 ? 0 : 1);
					a = row[i1];
					b = b < a ? (b < c ? b + 1 : c) : (a < c ? a + 1 : c);
					row[i1] = b;
				}
			}
			return b;
		} else {
			return s1_len + s2_len;
		}
	}
};

const launcher = () => {
	const AppItem = app => Widget.Button({
		on_clicked: () => {
			App.closeWindow("applauncher")
			app.launch()
		},
		class_names: ["nofocus", "focusleft"],
		attribute: { app },
		child: Widget.Box({
			children: [
				Widget.Icon({
					icon: app.icon_name || "",
					size: 28,
				}),
				Widget.Label({
					label: app.name,
					xalign: 0,
					vpack: "center",
					truncate: "end",
					css: "margin-left: 10px;",
				}),
			],
		}),
	})

    let applications = query("").map(AppItem)

    const list = Widget.Box({
        vertical: true,
        children: applications,
        spacing: 5
    })

    function repopulate() {
        applications = query("").map(AppItem)
		applications.sort((a, b) => a.attribute.app.name.toUpperCase().localeCompare(b.attribute.app.name.toUpperCase()))
        list.children = applications
    }

	const entry = Widget.Entry({
        hexpand: true,
		placeholder_text: "search...",
		class_names: ["launcherentrybox", "nofocus"],

        on_accept: () => {
			const results = applications.filter((item) => item.visible);
            if (results[0]) {
                App.toggleWindow("applauncher")
                results[0].attribute.app.launch()
            }
        },

        on_change: ({ text }) => {
			if(text != "") applications.sort((a, b) => lavenstein(a.attribute.app.name, text) - lavenstein(b.attribute.app.name, text))
			else applications.sort((a, b) => a.attribute.app.name.toUpperCase().localeCompare(b.attribute.app.name.toUpperCase()))
			list.children = applications
			applications.forEach(item => item.visible = item.attribute.app.match(text ?? ""))
		},
    })

	const apps = Widget.Scrollable({
		class_name: "launcherscrollable",
		hscroll: 'never',
		vscroll: 'always',
		child: list
	})

	return Widget.Box({
		vertical: true,
		class_name: "launcherbody",
		children: [
			Widget.Box({
				children: [
					Widget.Icon({
						icon: icon("search"),
						size: 10
					}),
					entry
				]
			}),
			apps
		],
		setup: self => self.hook(App, (_, visible) => {
            if (visible) {
                repopulate()
                entry.text = ""
                entry.grab_focus()
            }
        }),
	})
}

const menu = () => {
	const button = (icon_name, command) => Widget.Button({
		child: Widget.Icon({
			icon: icon(icon_name),
			size: 10,
		}),
		class_names: ["menubutton", "nofocus", "focusright"],
		on_clicked: () => {
			App.closeWindow("applauncher")
			Utils.exec(command)
		}
	})
	
	return Widget.Box({
		vertical: true,
		class_name: "menubox",
		children: [
			button("power", "systemctl poweroff"),
			button("reboot", "systemctl reboot"),
			button("lock", "hyprlock"),
			button("sleep", "suspend"),
			button("hibernate", "systemctl hibernate"),
			button("log-out", "hyprctl dispatch exit 1")
		]
	})
}

export const AppLauncher = Widget.Window({
	name: "applauncher",
	class_name: "launcher",
	exclusivity: "exclusive",
	keymode: "exclusive",
	margins: [100, 50],
	child: Widget.Box({
		spacing: 10,
		css: "margin: 10px;",
		children: [
			launcher(),
			menu()
		]
	}),
    visible: false,
	setup: self => self.keybind("Escape", () => App.closeWindow("applauncher")),
})

