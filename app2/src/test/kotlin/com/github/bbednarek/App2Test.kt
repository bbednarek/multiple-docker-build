package com.github.bbednarek

import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test

class App2Test {
    @Test
    fun appHasAGreeting() {
        val classUnderTest = App2()
        assertNotNull(classUnderTest.greeting, "app should have a greeting")
    }
}
