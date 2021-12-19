--[[
    PackType.
    
    Takes an array of numbers and converts it back into a value.
    
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Animation/packType.lua
    HawDevelopment
    12/18/2021
--]]


local Package = script.Parent.Parent
local Types = require(Package.Types)
local Oklab = require(Package.Colour.Oklab)

return function (value: {number}, typestr: string): Types.Animatable | nil
	if typestr == "number" then
		return value[1]
	elseif typestr == "CFrame" then
		return
			CFrame.new(value[1], value[2], value[3]) *
			CFrame.fromAxisAngle(
				Vector3.new(value[4], value[5], value[6]).Unit,
				value[7]
			)
	elseif typestr == "Color3" then
		return Oklab.from(
			Vector3.new(value[1], value[2], value[3]),
			false
		)
	elseif typestr == "ColorSequenceKeypoint" then
		return ColorSequenceKeypoint.new(
			value[4],
			Oklab.from(
				Vector3.new(value[1], value[2], value[3]),
				false
			)
		)
	elseif typestr == "DateTime" then
		return DateTime.fromUnixTimestampMillis(value[1])
	elseif typestr == "NumberRange" then
		return NumberRange.new(value[1], value[2])
	elseif typestr == "NumberSequenceKeypoint" then
		return NumberSequenceKeypoint.new(value[2], value[1], value[3])
	elseif typestr == "PhysicalProperties" then
		return PhysicalProperties.new(value[1], value[2], value[3], value[4], value[5])
	elseif typestr == "Ray" then
		return Ray.new(
			Vector3.new(value[1], value[2], value[3]),
			Vector3.new(value[4], value[5], value[6])
		)
	elseif typestr == "Rect" then
		return Rect.new(value[1], value[2], value[3], value[4])
	elseif typestr == "Region3" then
		-- FUTURE: support rotated Region3s if/when they become constructable
		local position = Vector3.new(value[1], value[2], value[3])
		local halfSize = Vector3.new(value[4] / 2, value[5] / 2, value[6] / 2)
		return Region3.new(position - halfSize, position + halfSize)
	elseif typestr == "Region3int16" then
		return Region3int16.new(
			Vector3int16.new(value[1], value[2], value[3]),
			Vector3int16.new(value[4], value[5], value[6])
		)
	elseif typestr == "UDim" then
		return UDim.new(value[1], value[2])
	elseif typestr == "UDim2" then
		return UDim2.new(value[1], value[2], value[3], value[4])
	elseif typestr == "Vector2" then
		return Vector2.new(value[1], value[2])
	elseif typestr == "Vector2int16" then
		return Vector2int16.new(value[1], value[2])
	elseif typestr == "Vector3" then
		return Vector3.new(value[1], value[2], value[3])
	elseif typestr == "Vector3int16" then
		return Vector3int16.new(value[1], value[2], value[3])
	else
		return nil
	end
end
