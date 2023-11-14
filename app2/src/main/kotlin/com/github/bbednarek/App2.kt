package com.github.bbednarek

class App2 {
    val greeting: String
        get() {
            return "Hello World!"
        }
}

fun main() {
    println(App2().greeting)
}
