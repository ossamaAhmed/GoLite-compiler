//we sort numbers using a heap
package heapsort

var index int
var size int = 10
var numbers [10]int
var global_heap [1000]int
var global_heapSize int

func main(){
  numbers[0] = 0
  numbers[1] = 17
  numbers[2] = 13
  numbers[3] = 8
  numbers[4] = 79
  numbers[5] = 65
  numbers[6] = 44
  numbers[7] = 72
  numbers[8] = 66
  numbers[9] = 53

  var heap [1000]int
  heapSort(10, numbers)

  var sorted []int
  sorted = getSortedList()
  // sorted now contains a sorted list of our numbers
}

func heapSort(size int, numbers []int) {
  var lastIndex int = 1
  var current = 1;
  var newIndex int
  var keepLooping bool
  var myHeap [1000]int
  var temp int

  myHeap[1] = numbers[0]

  var i int
  for i:= 1; i < size; i++ {
    lastIndex++
    myHeap[lastIndex] = numbers[i]

    keepLooping = true
    current = lastIndex
    
    for keepLooping {
      newIndex = current/2
      if newIndex > 0  && myHeap[newIndex] < myHeap[current] {
        temp = myHeap[newIndex]
        myHeap[newIndex] = myHeap[current]
        myHeap[current] = temp
        current = newIndex
      } else if newIndex == 0 {
        keepLooping = false;
      }
    }
  }
  global_heap = myHeap
  global_heapSize = lastIndex
}

func getSortedList() []int{
  var sorted []int
  var keepLooping bool
  var current int
  var temp int

  for global_heapSize > 0 {
    sorted = append(sorted, global_heap[1])
    global_heap[1] = global_heap[global_heapSize]
    global_heapSize--

    keepLooping = true
    current = 1
    for keepLooping {
      if current * 2 <= global_heapSize && global_heap[current] < global_heap[current*2] {
        temp = global_heap[current]
        global_heap[current] = global_heap[current*2]
        global_heap[current*2] = temp
        continue
      }

      if current*2+1 <= global_heapSize && global_heap[current] < global_heap[current*2+1] {
        temp = global_heap[current]
        global_heap[current] = global_heap[current*2+1]
        global_heap[current*2+1] = temp
        continue
      }

      keepLooping = false
    }
  }

  return sorted
}
