package main

import (
	"fmt"
)

type Test struct {
	Test1 string `json:"test_1"`
}

func main() {
	t := Test{Test1: "DRG"}
	fmt.Printf("this is test %s", t.Test1)
}
