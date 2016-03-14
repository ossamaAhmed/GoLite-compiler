package empty

// Legal empty distributed declarations
var()
type()

// Empty function body
func nothing() {}

func foo() {

    var x = true

    // Empty blocks
    {}


    // Nested empty blocks
    {
      {
        {
          {}
        }
      }
    }

    // Empty struct
    var p struct{}
    p = p //"use" p

    // Various empty statements
    ;;;;

    for ;; {}
    for {}

    if x {}
    if ; x {}

    if x {} else {}
    if x {} else if ; x {}
    if x {} else if x {}

    switch {}

    switch; {}

    // Legal: no statements in switch
    switch {
        case x:
        case x:
    }
}
