package continue_outise

func main() {
    switch os := runtime.GOOS; os {
    case "darwin":
        continue
    default:
        break
    }
}
