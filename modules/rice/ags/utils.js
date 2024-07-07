const hyprland = await Service.import("hyprland")
const battery = await Service.import("battery")
const audio = await Service.import('audio')
const network = await Service.import('network')

export {hyprland, battery, audio, network}

const cpu_usage_poll = 2000;
const cpu_frequency_poll = 2000;
const memory_usage_poll = 2000;

const cpu = Variable(0, {
	poll: [cpu_usage_poll, 'vmstat 1 2', out => (100 - Number(out.split('\n')[2].split(/\s+/)[15]))/100],
})

const cpuspeed = Variable(0, {
	poll: [cpu_frequency_poll, 'grep "^[c]pu MHz" /proc/cpuinfo', out => Math.floor(out.split('\n')
		.map(line => Number(line.split(/\s+/)[3]))
		.reduce((a, b, _, c) => a + b / c.length, 0))
	],
})

const ram = Variable([], { 
	// @ts-ignore
	poll: [memory_usage_poll, 'free', out => out.split('\n')
		.find(line => line.includes('Mem:')) 
		.split(/\s+/) 
		.map(v => Number(v))],
})

export {cpu, cpuspeed, ram}

const revealBox = (outer_widget, inner_widget, direction, extra_class = "", duration = 800) => {
	const isHovered = Variable(0)
	const isHoveredInner = Variable(0)

	return Widget.Box({
		class_names: ["revealbox", extra_class],
		children: [
			Widget.EventBox({
				child: outer_widget,
				on_hover: () => isHovered.setValue(1),
				on_hover_lost: () => isHovered.setValue(0),
				setup: self => self.hook(isHoveredInner, () => isHovered.setValue(isHoveredInner.getValue()))
			}),
			Widget.Revealer({
				reveal_child: false,
				transitionDuration: duration,
				transition: direction,
				child: Widget.EventBox({
					child: inner_widget,
					on_hover: () => isHoveredInner.setValue(1),
					on_hover_lost: () => isHoveredInner.setValue(0)
				}),
				setup: self => self.hook(isHovered, () => self.reveal_child = isHovered.getValue() == 1 ? true : false),
			}),
		]
	})
}

class BrightnessService extends Service {
    static {
        Service.register(
            this,
            { 'screen-changed': ['float'] },
            { 'screen-value': ['float', 'rw'] },
        );
    }

    #interface = Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");

    #screenValue = 0;
    #max = Number(Utils.exec('brightnessctl max'));

    get screen_value() {
        return this.#screenValue;
    }

    set screen_value(percent) {
        if (percent < 0) percent = 0;
        if (percent > 1) percent = 1;
        Utils.execAsync(`brightnessctl set ${percent * 100}% -q`);
    }

    constructor() {
        super();
        const brightness = `/sys/class/backlight/${this.#interface}/brightness`;
        Utils.monitorFile(brightness, () => this.#onChange());
        this.#onChange();
    }

    #onChange() {
        this.#screenValue = Number(Utils.exec('brightnessctl get')) / this.#max;
        this.emit('changed');
        this.notify('screen-value');
        this.emit('screen-changed', this.#screenValue);
    }

    connect(event = 'screen-changed', callback) {
        return super.connect(event, callback);
    }
}

const gigabytes = (/**@type{Number} */mem) => `${Math.floor(mem/10000)/100} GB`

const icon = (/**@type{String} */name) => `/home/krecony/.dotfiles/modules/rice/ags/icons/${name}.svg`

const circular = (val, tooltip) => Widget.CircularProgress({
	child: Widget.Label(""),
	value: val,
	tooltip_text: tooltip 
})

const service = new BrightnessService;
export default service;

export {revealBox, circular, icon, gigabytes}
