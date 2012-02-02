Spine ?= require('spine')

class ArrayCompare
  Array.prototype.ArrayCompare = ->
    return ArrayCompare.areArraysEqual(this.valueOf(), arguments)

  @areArraysEqual:(array1, array2)  ->
    temp = new Array()
    if ( (!array1[0]) || (!array2[0]) )
      return false;

    if (array1.length != array2.length)
      return false;

    for item in array1
      key = (typeof item) + "~" + item;
      if (temp[key]) then temp[key]++ else temp[key] = 1

    for item in array2
      key = (typeof item) + "~" + item;
      if (temp[key])
        if (temp[key] == 0) then return false else  temp[key]--
      else
        return false;
    return true;

module?.exports = ArrayCompare