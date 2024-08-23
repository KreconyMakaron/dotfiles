const Image = Widget.subclass(imports.gi.Gtk.Image)
const Pixbuf = imports.gi.GdkPixbuf.Pixbuf

const script_path = '/home/krecony/.dotfiles/modules/rice/ags'
const max_entry_count = 50

const clipboard = () => {
	const clipboard_text = (text, i) => Widget.Button({
		class_names: ["nofocus", "focusleft"],
		on_clicked: () => {
			Utils.exec(`bash -c "${script_path}/copy.sh ${i}"`)
			App.closeWindow("clipboard")
		},
		child: Widget.Label({
			label: text,
			xalign: 0,
			vpack: "center",
			truncate: "end",
		}),
	})

	const clipboard_image = (i) => {
		Utils.exec(`bash -c "${script_path}/decode.sh ${i} image"`)
		const img = Image({})
		const pixbuf = Pixbuf.new_from_file_at_scale("/tmp/clipboard_ags_image", 700, 300, true)
		img.set_from_pixbuf(pixbuf)

		return Widget.Button({
			class_names: ["nofocus", "focusleft"],
			on_clicked: () => {
				Utils.exec(`bash -c "${script_path}/copy.sh ${i}"`)
				App.closeWindow("clipboard")
			},
			child: img
		})
	}

	let items = []

	const list = Widget.Box({
        vertical: true,
        children: items,
        spacing: 10
    })

	const repopulate = () => {
		const entry_count = Math.min(max_entry_count, Number(Utils.exec('bash -c "cliphist list | wc -l"')))

		items = []
		let i = 1

		while(i <= entry_count) {
			try {
				items.push(clipboard_text(Utils.exec(`${script_path}/decode.sh ${i}`).toString(), i))
			}
			catch {
				try {
					items.push(clipboard_image(i))
				}
				catch {
					logError("couldn't load non UTF-8 clipboard item as an image :c")
				}
			}
			i++
		}

		list.children = items
	}

	const scrollable = Widget.Scrollable({
		class_name: 'clipboardbody',
		hscroll: 'never',
		vscroll: 'always',
		child: list

	})

	return Widget.Box({
		child: scrollable,
		setup: self => self.hook(App, (_, windowName, visible) => {
			if(windowName == "clipboard" && visible) {
				repopulate()
				list.children.at(0).grab_focus()
			}
        }),
	})
}

export const Clipboard = Widget.Window({
	name: 'clipboard',
	class_name: 'clipboard',
	anchor: ["bottom", "right"],
	visible: false,
	exclusivity: "exclusive",
	keymode: "exclusive",
	child: clipboard(),
	setup: self => self.keybind("Escape", () => App.closeWindow("clipboard")),
})

