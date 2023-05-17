package tech.bunkbed.squadmaker

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform