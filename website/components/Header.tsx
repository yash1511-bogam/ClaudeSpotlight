"use client"

import { Button } from "./ui/button"
import { Download, Github } from "lucide-react"

import { handleDownload } from "../lib/download"

export default function Header() {
  return (
    <header className="fixed top-0 w-full z-50 border-b border-white/10 bg-black/50 backdrop-blur-xl">
      <div className="container mx-auto px-4 md:px-6 lg:px-8 py-3 md:py-4 flex items-center justify-between">
        <div className="flex items-center space-x-2">
          <div className="w-7 h-7 md:w-8 md:h-8 rounded-lg bg-gradient-to-br from-emerald-500 to-cyan-500 flex items-center justify-center">
            <span className="text-white font-bold text-base md:text-lg">C</span>
          </div>
          <span className="text-base md:text-xl font-bold text-white">ClaudeSpotlight</span>
        </div>
        
        <nav className="hidden md:flex items-center space-x-6 lg:space-x-8">
          <a href="#features" className="text-sm lg:text-base text-gray-300 hover:text-white transition-colors">
            Features
          </a>
          <a href="#faq" className="text-sm lg:text-base text-gray-300 hover:text-white transition-colors">
            FAQ
          </a>
          <a 
            href="https://github.com/yash1511-bogam/ClaudeSpotlight" 
            target="_blank"
            rel="noopener noreferrer"
            className="text-gray-300 hover:text-white transition-colors"
          >
            <Github className="w-5 h-5" />
          </a>
        </nav>

        <Button onClick={handleDownload} className="bg-white text-black hover:bg-gray-200 text-xs md:text-sm px-3 md:px-4 h-8 md:h-10">
          <Download className="w-3 h-3 md:w-4 md:h-4 mr-1 md:mr-2" />
          <span className="hidden sm:inline">Download</span>
          <span className="sm:hidden">Get</span>
        </Button>
      </div>
    </header>
  )
}
