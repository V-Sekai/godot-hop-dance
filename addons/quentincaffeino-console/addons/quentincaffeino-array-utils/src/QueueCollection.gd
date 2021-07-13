
extends 'res://addons/quentincaffeino-console/addons/quentincaffeino-array-utils/src/Collection.gd' # Collection.gd


# @var  int
var _maxLength = -1


func getMaxLength():  # int
	return self._maxLength

# @param  int  maxLength
func setMaxLength(maxLength):  # QueueCollection
	self._maxLength = maxLength
	return self


# @param  Variant  value
func push(value):  # QueueCollection
	if self._length >= 0 and self.last() == value:
		return

	if self._length == self.getMaxLength():
		self.pop()

	self.add(value)
	self.last()
	return self


func pop():  # Variant
	var value = self.getByIndex(0)
	self.removeByIndex(0)
	return value
