"use client"

import { Button } from "./ui/button"
import { Download, Command } from "lucide-react"
import { handleDownload } from "../lib/download"

export default function Hero() {
  return (
    <section className="pt-24 md:pt-32 pb-12 md:pb-20 px-4 md:px-6">
      <div className="container mx-auto max-w-5xl text-center">
        <div className="inline-flex items-center space-x-2 px-3 md:px-4 py-1.5 md:py-2 rounded-full bg-emerald-950/40 border border-emerald-500/30 mb-6 md:mb-8">
          <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          <span className="text-xs md:text-sm text-emerald-300">macOS 15.0+ (Sequoia)</span>
        </div>

        <h1 className="text-3xl sm:text-4xl md:text-6xl lg:text-7xl font-bold text-white mb-4 md:mb-6 leading-tight px-2">
          Claude AI at Your
          <span className="block bg-gradient-to-r from-emerald-400 to-cyan-400 bg-clip-text text-transparent">
            Fingertips
          </span>
        </h1>

        <p className="text-base md:text-lg lg:text-xl text-gray-400 mb-8 md:mb-12 max-w-2xl mx-auto px-4">
          A native macOS app that brings Claude AI to your desktop with an authentic 
          Spotlight-like interface. Just press ⌘⇧Space and start chatting.
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-3 md:gap-4 px-4">
          <Button onClick={handleDownload} size="lg" className="bg-white text-black hover:bg-gray-200 text-sm md:text-base lg:text-lg px-6 md:px-8 w-full sm:w-auto">
            <Download className="w-4 h-4 md:w-5 md:h-5 mr-2" />
            Download for macOS
          </Button>
          <a href="https://github.com/yash1511-bogam/ClaudeSpotlight" target="_blank" rel="noopener noreferrer">
            <Button 
              size="lg" 
              variant="outline" 
              className="border-white/20 text-white hover:bg-white/10 text-sm md:text-base lg:text-lg px-6 md:px-8 w-full sm:w-auto"
            >
              <Command className="w-4 h-4 md:w-5 md:h-5 mr-2" />
              View on GitHub
            </Button>
          </a>
        </div>

        <div className="mt-10 md:mt-16 relative px-2">
          <div className="absolute inset-0 bg-gradient-to-r from-emerald-500/20 to-cyan-500/20 blur-3xl"></div>
          <div className="relative rounded-xl md:rounded-2xl border border-emerald-500/20 bg-black/40 backdrop-blur-xl p-4 md:p-8 shadow-2xl">
            <div className="flex items-center space-x-2 mb-3 md:mb-4">
              <div className="w-2.5 h-2.5 md:w-3 md:h-3 rounded-full bg-red-500"></div>
              <div className="w-2.5 h-2.5 md:w-3 md:h-3 rounded-full bg-yellow-500"></div>
              <div className="w-2.5 h-2.5 md:w-3 md:h-3 rounded-full bg-green-500"></div>
            </div>
            <div className="text-left space-y-2 md:space-y-3 text-xs md:text-sm">
              <div className="text-emerald-400">$ Ask Claude anything...</div>
              <div className="text-cyan-300 break-words">⌘⇧Space to launch • Real-time streaming • Multiple providers</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
