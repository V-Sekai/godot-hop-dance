
extends 'res://addons/quentincaffeino-console/src/Type/BaseRegexCheckedType.gd'


func _init():
	pass


# @param    Variant  value
# @returns  int
func normalize(value):
	return (self._reextract(value)).to_int()
