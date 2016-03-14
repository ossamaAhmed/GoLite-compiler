/* First sort a given array using selection sort, then do binary search on the
 * sorted array to find the index of the target. */

package main

// Array to be sorted.
var nums []int

/* Main */
func main() {
  nums = append(nums, 10)
  nums = append(nums, 9)
  nums = append(nums, 8)
  nums = append(nums, 7)
  nums = append(nums, 6)
  nums = append(nums, 5)
  nums = append(nums, 4)
  nums = append(nums, 3)
  nums = append(nums, 2)
  nums = append(nums, 1)

  selectionSort(nums, 10)
  println(binarySearch(nums, 10, 10) >= 0)
}

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
}

/* Binary Search */
func binarySearch(nums []int, size int, target int) int {
  low := 0
  high := size - 1

  for low <= high {
    mid := (low + high) / 2
    if nums[mid] < target {
      low = mid + 1
    } else if nums[mid] > target {
      high = mid - 1
    } else {
      return mid
    }
  }

  return -1
}
