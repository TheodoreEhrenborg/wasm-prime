#!/usr/bin/env bash
wasm-pack build --target web && elm make Main.elm --output=elm.js
