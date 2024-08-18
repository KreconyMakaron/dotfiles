import {Bar} from './bar.js'
import {AppLauncher} from './applauncher.js'
import {Clipboard} from './clipboard.js'

App.config({
	style: './style.css',
    windows: [
		Bar(0),
		AppLauncher,
		Clipboard
	],
})

