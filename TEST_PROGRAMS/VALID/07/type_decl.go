package main

type (
	Point struct {
		x, y float64
	}
	Polar Point
)

type TreeNode struct {
	left, right TreeNode
	value Comparable
}

type num int // simple type alias
type point struct { // point is a struct
	x, y float64
}

type (
	num int
	point struct {
		x, y float64
	}
)
