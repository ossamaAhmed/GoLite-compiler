/*** Xoey checks factors of a number **/
package main

func factors(num int) []int {
	var arr []int
	for i := 2; num > i; i++ {
		if num%i == 0 {
			arr = append(arr, i)
		}
	}
	return arr
}
