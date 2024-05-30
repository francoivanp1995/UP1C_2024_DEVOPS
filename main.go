package main

import (
	"fmt"
	"net/http"
)

func Handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "¡Hola Mundo!")
}

func main() {
	http.HandleFunc("/", Handler)
	fmt.Println("La aplicación está escuchando en http://localhost:8000")
	http.ListenAndServe(":8000", nil)
}
