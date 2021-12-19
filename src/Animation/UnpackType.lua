--[[
    UnpackType.
    
    Returns the value as an array of numbers. If the values cant be animated, then an empty array is returned.
    
    Taken from fusion: https://github.com/Elttob/Fusion/blob/main/src/Animation/unpackType.lua
    HawDevelopment
    12/18/2021
--]]

local Package = script.Parent.Parent
local Oklab = require(Package.Colour.Oklab)

return function (value: any, typestr: string): { number }
    if typestr == "number" then
		local value = value :: number
		return {value}
	elseif typestr == "CFrame" then
		local axis, angle = value:ToAxisAngle()
		return {value.X, value.Y, value.Z, axis.X, axis.Y, axis.Z, angle}
	elseif typestr == "Color3" then
		local lab = Oklab.to(value)
		return {lab.X, lab.Y, lab.Z}
	elseif typestr == "ColorSequenceKeypoint" then
		local lab = Oklab.to(value.Value)
		return {lab.X, lab.Y, lab.Z, value.Time}
	elseif typestr == "DateTime" then
		return {value.UnixTimestampMillis}
	elseif typestr == "NumberRange" then
		return {value.Min, value.Max}
	elseif typestr == "NumberSequenceKeypoint" then
		return {value.Value, value.Time, value.Envelope}
	elseif typestr == "PhysicalProperties" then
		return {value.Density, value.Friction, value.Elasticity, value.FrictionWeight, value.ElasticityWeight}
	elseif typestr == "Ray" then
		return {value.Origin.X, value.Origin.Y, value.Origin.Z, value.Direction.X, value.Direction.Y, value.Direction.Z}
	elseif typestr == "Rect" then
		return {value.Min.X, value.Min.Y, value.Max.X, value.Max.Y}
	elseif typestr == "Region3" then
		return {
			value.CFrame.X, value.CFrame.Y, value.CFrame.Z,
			value.Size.X, value.Size.Y, value.Size.Z
		}
	elseif typestr == "Region3int16" then
		return {value.Min.X, value.Min.Y, value.Min.Z, value.Max.X, value.Max.Y, value.Max.Z}
	elseif typestr == "UDim" then
		return {value.Scale, value.Offset}
	elseif typestr == "UDim2" then
		return {value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset}
	elseif typestr == "Vector2" then
		return {value.X, value.Y}
	elseif typestr == "Vector2int16" then
		return {value.X, value.Y}
	elseif typestr == "Vector3" then
		return {value.X, value.Y, value.Z}
	elseif typestr == "Vector3int16" then
		return {value.X, value.Y, value.Z}
	else
		return {}
	end
end