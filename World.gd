class Tile:
	var type
	var basehp

func tile(type, basehp):
	var result = Tile.new()
	result.type = type
	result.basehp = basehp
	return result

var chunkHeight = 35
var chunkWidth = 10

var titleList = [
	"Solar System",
	"Solar System",
]

var subtitleList = [
	"Space Debris",
	"Asteroid Belt",
]

var worldList = []

var blueprints = [
	# percent of it occuring, health scaling, method to put on map, list of tiles
	[
		[30, "oneperrow", [
			[null ,null, null],
			[null ,["lifeblock", 2, 1.2], null],
			[null ,null, null],
		]], 
		[220, "rep", [
			[["block", 1, 2]],
		]]
	],
	
	[
		[30, "oneperrow", [
			[0,null,0],
			[null,["block", 15, 1.4],null],
			[["block", 15, 2],["lifeblock", 1, 0],["block", 15, 2]],
			[null,["block", 15, 2],null],
			[0,null,0],
		]]
	],
]

func scaleHp(world, blueprints):
	var hpLevel = 0
	for i in range(len(world)):
		for j in range(len(world[0])):
			if typeof(world[i][j]) != 2 and typeof(world[i][j]) != 0:
				world[i][j][1] += floor((hpLevel / 2) * world[i][j][2])
				if world[i][j][0] == "lifeblock":
					hpLevel += 1
				
						
	return world

func pRandomSpreadWithRepetitions(world, blueprint, rep):
	randomize()
	var count = blueprint[0]
	var structure = blueprint[2]
	var repcount = 0
	var rx
	var ry
	var foundPlace = true
	for c in range(count):
		repcount = 0
		foundPlace = true
		while repcount < rep:
			rx = randi() % chunkWidth
			ry = randi() % chunkHeight
			for i in range(len(structure)):
				for j in range(len(structure[0])):
					if ry+i < chunkHeight and rx+j < chunkWidth:
						if typeof(world[ry+i][rx+j]) != 2:
							foundPlace = false
					else:
						foundPlace = false
			if foundPlace:
				break
			repcount += 1
		if repcount == rep:
			foundPlace = false
		if foundPlace:
			for i in range(len(structure)):
				for j in range(len(structure[0])):
					if structure[i][j] != null:
						if typeof(structure[i][j]) != 2:
							world[ry+i][rx+j] = [] + structure[i][j]
						else:
							world[ry+i][rx+j] = 0
					else:
						world[ry+i][rx+j] = null
	return world

func pOneElemPerRowWithRandomX(world, blueprint):
	var structure = blueprint[2]
	var rx = []
	var foundPlace = true
	var foundx
	for row in range(len(world)):
		for x in range(chunkWidth):
			rx.append(x)
		rx.shuffle()
		for x in rx:
			foundPlace = true
			#print("checking ", row, " x = ", x)
			for i in range(len(structure)):
				for j in range(len(structure[0])):
					if row+i < chunkHeight and x+j < chunkWidth:
						if typeof(world[row+i][x+j]) != 2:
							foundPlace = false
							foundx = null
					else:
						foundPlace = false
						foundx = null
				if !foundPlace:
					break
					foundx = null
			if foundPlace:
				foundx = x
				break
		if foundx != null:
			#print("found place ", row, " ", foundx)
			for i in range(len(structure)):
				for j in range(len(structure[0])):
					if structure[i][j] != null:
						if typeof(structure[i][j]) != 2:
							world[row+i][foundx+j] = [] + structure[i][j]
						else:
							world[row+i][foundx+j] = 0
					else:
						world[row+i][foundx+j] = null
	return world

func newData(region):
	var trow = []
	for j in range(10):
		trow.append(0)
	var tempList = []
	for i in range(chunkHeight):
		tempList.append([] + trow)
	var taken = []
	var blueprint
	var rng
	var blockToAdd
	var added = false
	
	if region == 0:
		blueprint = blueprints[0]
	elif region == 1:
		blueprint = blueprints[1]
	
	for elem in blueprint:
		if elem[1] == "rep":
			tempList = pRandomSpreadWithRepetitions(tempList, elem, 15)
		elif elem[1] == "oneperrow":
			tempList = pOneElemPerRowWithRandomX(tempList, elem)
	
	tempList = scaleHp(tempList, blueprint)
	for e in tempList:
		print(e)
	for i in tempList:
		worldList.append(i)
