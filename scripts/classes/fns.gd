extends Node

class_name Fns

const E = 2.718281828459045
'''
Deep clones an array of objects.
The objects class must have a clone method.
'''
static func clone(arr:Array):
	return arr.map(func(i):return i.clone())
	
# takes  2d arrays of shape: n by 1
static func mat_add(a, b):
	var a_row = a.size()
	var b_row = b.size()
	var a_col = a[0].size()
	var b_col = b[0].size()
	
	var res = []
	if a_row == b_row and a_col == b_col:
		for i in range(a_row):
			res.append([a[i][0]+b[i][0]])
	return res

# returns a 2d random mat: rows x cols
static func rand_mat(rows:=1, cols:=1, min:=-1, max:=1):
	var matrix = []
	for i in range(rows): 
		matrix.append([])
		for j in range(cols):
			matrix[i].append(randf_range(min, max))
	return matrix

# takes a 2d array of shape: rows x cols
static func mat_mul(a, b):
	var a_row = a.size()
	var b_row = b.size()
	var a_col = a[0].size()
	var b_col = b[0].size()
	
	if a_col != b_row:
		print(b_col)
		return "matrix not same size"
		
	var res = []
	for i in range(a_row):
		res.append([])
		for j in range(b_col):
			var sum_of_v = 0
			for k in range(b_row):
				var v = a[i][k] * b[k][j]
				sum_of_v += v
			res[i].append((sum_of_v))
	return res
	
static func choice(array:Array, p:Array):
	var total_p = 0.0
	var cumulative_p = []
	for i in p:
		total_p += i
		cumulative_p.append(total_p)
		
	var rnd = randf_range(0.0, total_p)
	var idx
	for i in range(cumulative_p.size()):
		if cumulative_p[i] > rnd or cumulative_p[i] == rnd:
			idx = i
			break
	return array[idx]

static func probabilities(arr:Array):
	var total = arr.reduce(func(accum, n): return accum + n)
	var probabilities = arr.map(func(score): return score / total)
	return probabilities
