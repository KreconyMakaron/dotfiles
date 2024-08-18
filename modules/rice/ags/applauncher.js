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
		attribute: { app },
		child: Widget.Box({
			children: [
				Widget.Icon({
					icon: app.icon_name || "",
					size: 30,
				}),
				Widget.Label({
					class_name: "title",
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
		class_name: "launcherentrybox",

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

	const bar = Widget.CenterBox({
		class_name: "launcherbar",
		start_widget: Widget.Box({
			children: [ entry ],
		})
	})

	const apps = Widget.Scrollable({
		class_name: "launcherbody",
		hscroll: 'never',
		vscroll: 'always',
		child: list
	})

	return Widget.Box({
		spacing: 5,
		vertical: true,
		children: [
			bar,
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

export const AppLauncher = Widget.Window({
	name: "applauncher",
	class_name: "launcher",
	exclusivity: "exclusive",
	keymode: "exclusive",
	margins: [100, 50],
	child: launcher(),
    visible: false,
	setup: self => self.keybind("Escape", () => App.closeWindow("applauncher")),
})

