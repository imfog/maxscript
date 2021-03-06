(
local coord=#world

---------------------------------------------------------------------------------
-- utility functions
--

	fn round val n:2=
	(
		local p=10^n
		val=floor(val*p)/p
		if abs val < 0.1 then val=0
		return val
	)


---------------------------------------------------------------------------------
-- space conversion functions
--
	local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]--XZY
	local mxZUP=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]--XYZ

	fn getPos obj =
	(
		local v=obj.pos
		local p3=Point3 (round v.x) (-round v.z) (round v.y)
		return p3
	)

	fn getRot obj =
	(
		in coordsys mxYUP local v=obj.rotation as eulerangles
		local p3=Point3 (round -v.x) (round v.y) (round v.z)
		return p3
	)

	fn getScale obj =
	(
		local v=obj.scale
		local p3=Point3 (round v.x) (round v.z) (round v.y)
		return p3
	)

---------------------------------------------------------------------------------
-- object property conversion functions
--

	fn getCamZoom obj h:600=
	(
		return round ((h.value/2)/(tan (obj.fov/2)))
	)

	fn getLightIntensity obj =
	(
		return obj.multiplier*100
	)

	fn getLightConeAngle obj =
	(
		return obj.falloff
	)

	fn getLightConeFeather obj =
	(
		return round (100-(obj.hotspot/obj.falloff*100))
	)

	fn getColor col =
	(
		return point3 (col.r/255.0) (col.g/255.0) (col.b/255.0)
	)

	fn getTime t =
	(
		return t as float/4800
	)
		

---------------------------------------------------------------------------------
-- cycle 1
--

fn getValues obj start:animationRange.start end:animationRange.end increment:1=
(
	tStr=stringstream ""
	vStr=stringstream ""

	for t = start to end by increment do
	(
		at time t
		(
			p=obj.pos
			--format "%" ((currenttime as integer) / (4800/framerate)) to:tStr
			format "%" (round(t as float/4800) n:3) to:tStr

			format "[%,%,%]" (round p.x) -(round p.z) (round p.y) to:vStr
			if t<end then
			(
				format "," to:tStr
				format "," to:vStr
			)
		)
	)
	return #(tStr,vStr)
)

(
	t=timestamp()
	arr=getValues $ increment:10
	format "[%],\n[%]\n" (arr[1] as string) (arr[2] as string)
	format "DONE: %\n" (timestamp()-t)
)


---------------------------------------------------------------------------------
-- cycle 2
--

local frames=for i = 1f to 100f collect i

fn getValues obj=
(
	tStr=stringstream ""
	vStr=stringstream ""
	
	tArr=for t in frames collect (getTime t)
	vArr=for t in frames collect (at time t getPos obj)

	for i = 1 to tArr.count do
	(
		format "%" tArr[i] to:tStr
		format "%" vArr[i] to:vStr
		if i<tArr.count then
		(
			format "," to:tStr
			format "," to:vStr
		)
	)
	return #(tStr,vStr)
)



(
	t=timestamp()
	arr=getValues $ increment:10
	format "[%],\n[%]\n" (arr[1] as string) (arr[2] as string)
	format "DONE: %\n" (timestamp()-t)
)

)