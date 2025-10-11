"use client"

import { 
  Zap, 
  Globe, 
  Keyboard, 
  Shield, 
  Terminal, 
  Sparkles,
  Layers,
  Clock
} from "lucide-react"

const features = [
  {
    icon: Zap,
    title: "Spotlight Interface",
    description: "Floating window positioned at the top of your screen, just like macOS Spotlight. Press ⌘⇧Space anywhere to invoke.",
    gradient: "from-emerald-500 to-cyan-500"
  },
  {
    icon: Sparkles,
    title: "Claude 3.5 Sonnet",
    description: "Powered by the latest Claude AI model with real-time streaming responses and full context awareness.",
    gradient: "from-yellow-500 to-orange-500"
  },
  {
    icon: Globe,
    title: "Multiple Providers",
    description: "Switch between Anthropic Direct, Vertex AI, and AWS Bedrock. Choose your preferred provider on the fly.",
    gradient: "from-teal-500 to-emerald-500"
  },
  {
    icon: Terminal,
    title: "Command Execution",
    description: "Execute terminal commands safely with built-in danger detection and user confirmation. View output inline.",
    gradient: "from-lime-500 to-green-500"
  },
  {
    icon: Keyboard,
    title: "Keyboard-First",
    description: "Global shortcuts, instant focus, and efficient navigation. Designed for power users who love the keyboard.",
    gradient: "from-cyan-500 to-teal-500"
  },
  {
    icon: Shield,
    title: "Privacy & Security",
    description: "Sandboxed environment, hardened runtime, and minimal permissions. Your data stays on your Mac.",
    gradient: "from-red-500 to-rose-500"
  },
  {
    icon: Layers,
    title: "Native macOS",
    description: "Built with Swift 6.0 and SwiftUI. Ultra-thin material blur, SF Symbols, and Apple HIG compliant design.",
    gradient: "from-orange-500 to-amber-500"
  },
  {
    icon: Clock,
    title: "Launch at Login",
    description: "Automatically starts with macOS and runs quietly in the menu bar. Always ready when you need it.",
    gradient: "from-green-500 to-lime-500"
  }
]

export default function Features() {
  return (
    <section id="features" className="py-12 md:py-16 lg:py-20 px-4 md:px-6">
      <div className="container mx-auto max-w-6xl">
        <div className="text-center mb-10 md:mb-16">
          <h2 className="text-3xl md:text-4xl lg:text-5xl font-bold text-white mb-3 md:mb-4">
            Powerful Features
          </h2>
          <p className="text-base md:text-lg lg:text-xl text-gray-400 px-4">
            Everything you need for seamless AI assistance on macOS
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {features.map((feature, index) => {
            const Icon = feature.icon
            return (
              <div 
                key={index}
                className="group p-4 md:p-6 rounded-xl md:rounded-2xl border border-emerald-500/20 bg-emerald-950/20 hover:bg-emerald-900/20 transition-all duration-300 hover:scale-105 hover:border-emerald-500/40"
              >
                <div className={`w-10 h-10 md:w-12 md:h-12 rounded-lg md:rounded-xl bg-gradient-to-br ${feature.gradient} flex items-center justify-center mb-3 md:mb-4 group-hover:scale-110 transition-transform`}>
                  <Icon className="w-5 h-5 md:w-6 md:h-6 text-white" />
                </div>
                <h3 className="text-base md:text-lg font-semibold text-white mb-2">
                  {feature.title}
                </h3>
                <p className="text-xs md:text-sm text-gray-400 leading-relaxed">
                  {feature.description}
                </p>
              </div>
            )
          })}
        </div>
      </div>
    </section>
  )
}
