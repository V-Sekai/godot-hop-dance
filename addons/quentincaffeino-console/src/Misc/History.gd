
extends 'res://addons/quentincaffeino-console/src/Misc/../../addons/quentincaffeino-array-utils/src/QueueCollection.gd' #super../../addons/quentincaffeino-array-utils/src/QueueCollection.gd

var _console

# @param  int  maxLength
func _init(console, maxLength):
	self._console = console
	self.setMaxLength(maxLength)


# @returns  History
func print_all():
	var i = 1
	for command in self.getValueIterator():
		self._console.write_line(\
			'[b]' + str(i) + '.[/b] [color=#ffff66][url=' + \
			command + ']' + command + '[/url][/color]')
		i += 1

	return self
