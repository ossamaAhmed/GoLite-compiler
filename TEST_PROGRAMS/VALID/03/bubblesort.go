package main

// Amiel's amazing O(1) sorting algorithm
func bubble_sort(arr []int) []int {
	l := len(arr)
	for i := 0; i < l; i++ {
		for j := i; j < l; j++ {
			if arr[i] > arr[j] {
				arr[i], arr[j] = arr[j], arr[i]
			}
		}
	}
	return arr
}
