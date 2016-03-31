/* Array access directly on function call returning an array. */

package main

/* Selection Sort */
func selectionSort(nums []int, size int) {
  	for i := 0; i < size; i++ {
    	min := i
	    for j := i + 1; j < size; j++ {
			if nums[min] > nums[j] {
				min = j
			}
	    }

	    temp := nums[i]
	    nums[i] = nums[min]
	    nums[min] = temp
  	}

  	return nums
}

func main() {
	var array []int
	size := 4

	array = append(array, 23)
	array = append(array, 62)
	array = append(array, 80)
	array = append(array, 17)

	print("Min.: ")
	println(selectionSort(array, size)[0])

	print("Max.: ")
	println(selectionSort(array, size)[size - 1])
}
