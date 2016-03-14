// Check if an array is a heap
package main

func check_heap(arr []int) bool {
	l := len(arr)
	for i := 0; i < l; i++ {
		if 2*i+1 < l && arr[2*i+1] < arr[i] {
			return false
		}
		if 2*i+2 < l && arr[2*i+2] < arr[i] {
			return false
		}
	}
	return true
}
