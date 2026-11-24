package aimledger

import "testing"

func TestBetterPrefersHigherScore(t *testing.T) {
	a := &Player{Best: 900}
	b := &Player{Best: 400}
	if !better(a, b) {
		t.Fatal("higher score should rank first")
	}
	if better(b, a) {
		t.Fatal("lower score should not rank first")
	}
}

func TestRenderContainsGameCopy(t *testing.T) {
	out := Render("")
	if len(out) < 100 {
		t.Fatal("render output unexpectedly short")
	}
}
