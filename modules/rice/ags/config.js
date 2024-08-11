import {Bar} from './bar.js'
import {AppLauncher} from './applauncher.js'

const bar1 = Bar(0)

App.config({
	style: './style.css',
    windows: [
		bar1,
		AppLauncher
	],
})

