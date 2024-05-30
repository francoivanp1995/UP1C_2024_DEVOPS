package main

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rec := httptest.NewRecorder()
	Handler(rec, req)

	if status := rec.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	res := rec.Result()
	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		t.Fatal(err)
	}

	expected := "¡Hola Mundo!"
	if string(body) != expected {
		t.Errorf("handler returned unexpected body: got %v want %v",
			string(body), expected)
	}
}
