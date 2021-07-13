
const _ev1 = {
		"scancode": KEY_QUOTELEFT,
	}
const _ev1a = [_ev1]
# @var  String
const action_console_toggle = {
	"name": 'quentincaffeino_console_toggle',
	"events": _ev1
}

const _ev2 = {
		"scancode": KEY_TAB,
	}
const _ev2a = [_ev2]
# @var  String
const action_console_autocomplete = {
	"name": 'quentincaffeino_console_autocomplete',
	"events": _ev2a
}

const _ev3 = {
		"scancode": KEY_UP,
	}
const _ev3a = [_ev3]
# @var  String
const action_console_history_up = {
	"name": 'quentincaffeino_console_history_up',
	"events": _ev3a
}

const _ev4 = {
		"scancode": KEY_DOWN,
	}
const _ev4a = [_ev4]
# @var  String
const action_console_history_down = {
	"name": 'quentincaffeino_console_history_down',
	"events": _ev4a
}


# @var  Dictionary
const actions = {
	action_console_toggle.name: action_console_toggle,
	action_console_autocomplete.name: action_console_autocomplete,
	action_console_history_up.name: action_console_history_up,
	action_console_history_down.name: action_console_history_down
}
