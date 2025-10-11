"use client"

import { Github, Twitter, Mail } from "lucide-react"

export default function Footer() {
  return (
    <footer className="border-t border-white/10 py-8 md:py-12 px-4 md:px-6">
      <div className="container mx-auto max-w-6xl">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 md:gap-8 mb-6 md:mb-8">
          <div className="col-span-1 md:col-span-2">
            <div className="flex items-center space-x-2 mb-3 md:mb-4">
              <div className="w-7 h-7 md:w-8 md:h-8 rounded-lg bg-gradient-to-br from-emerald-500 to-cyan-500 flex items-center justify-center">
                <span className="text-white font-bold text-base md:text-lg">C</span>
              </div>
              <span className="text-lg md:text-xl font-bold text-white">ClaudeSpotlight</span>
            </div>
            <p className="text-sm md:text-base text-gray-400 mb-4 max-w-sm">
              A native macOS app that brings Claude AI to your desktop with an authentic Spotlight-like interface.
            </p>
            <div className="flex items-center space-x-4">
              <a 
                href="https://github.com/yash1511-bogam/ClaudeSpotlight" 
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-400 hover:text-white transition-colors"
              >
                <Github className="w-5 h-5" />
              </a>
              <a 
                href="#" 
                className="text-gray-400 hover:text-white transition-colors"
              >
                <Twitter className="w-5 h-5" />
              </a>
              <a 
                href="#" 
                className="text-gray-400 hover:text-white transition-colors"
              >
                <Mail className="w-5 h-5" />
              </a>
            </div>
          </div>

          <div>
            <h3 className="text-white font-semibold mb-3 md:mb-4 text-sm md:text-base">Product</h3>
            <ul className="space-y-2">
              <li>
                <a href="#features" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  Features
                </a>
              </li>
              <li>
                <a href="#faq" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  FAQ
                </a>
              </li>
              <li>
                <a href="https://github.com/yash1511-bogam/ClaudeSpotlight/releases" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  Download
                </a>
              </li>
              <li>
                <a href="https://github.com/yash1511-bogam/ClaudeSpotlight" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  GitHub
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h3 className="text-white font-semibold mb-3 md:mb-4 text-sm md:text-base">Resources</h3>
            <ul className="space-y-2">
              <li>
                <a href="https://github.com/yash1511-bogam/ClaudeSpotlight/blob/master/README.md" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  Documentation
                </a>
              </li>
              <li>
                <a href="https://github.com/yash1511-bogam/ClaudeSpotlight/blob/master/QUICKSTART.md" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  Quick Start
                </a>
              </li>
              <li>
                <a href="https://github.com/yash1511-bogam/ClaudeSpotlight/blob/master/SECURITY.md" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  Security
                </a>
              </li>
              <li>
                <a href="https://github.com/yash1511-bogam/ClaudeSpotlight/blob/master/LICENSE" className="text-sm md:text-base text-gray-400 hover:text-white transition-colors">
                  License
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div className="pt-6 md:pt-8 border-t border-white/10 flex flex-col md:flex-row items-center justify-between gap-3 md:gap-0">
          <p className="text-gray-400 text-xs md:text-sm text-center md:text-left">
            © 2024 ClaudeSpotlight. Open source under MIT License.
          </p>
          <p className="text-gray-400 text-xs md:text-sm text-center md:text-right">
            Built with Swift 6.0 • macOS 15.0+
          </p>
        </div>
      </div>
    </footer>
  )
}
