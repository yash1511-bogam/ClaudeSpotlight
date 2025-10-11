"use client"

import { useState } from "react"
import { ChevronDown } from "lucide-react"
import { cn } from "@/lib/utils"

const faqs = [
  {
    question: "What is ClaudeSpotlight?",
    answer: "ClaudeSpotlight is a native macOS app that brings Claude AI to your desktop with a Spotlight-like interface. Press ⌘⇧Space anywhere to invoke it, type your question, and get instant AI-powered responses."
  },
  {
    question: "What macOS version do I need?",
    answer: "ClaudeSpotlight requires macOS 15.0 (Sequoia) or later. It's built with the latest Swift 6.0 and SwiftUI technologies to provide the best native macOS experience."
  },
  {
    question: "Do I need an API key?",
    answer: "Yes, you need an API key from one of the supported providers: Anthropic Direct (recommended), Vertex AI, or AWS Bedrock. The Anthropic API key is the easiest to set up - just get it from console.anthropic.com and set the ANTHROPIC_API_KEY environment variable."
  },
  {
    question: "Is my data private and secure?",
    answer: "Absolutely. ClaudeSpotlight runs in a sandboxed environment with hardened runtime security. All API communication is encrypted over HTTPS, and no data is stored on external servers. Your conversations stay between you and your chosen AI provider."
  },
  {
    question: "Can I execute terminal commands?",
    answer: "Yes! ClaudeSpotlight features inline terminal command execution with built-in safety analysis. Commands are categorized by danger level (Safe/Warning/Dangerous) and always require your explicit confirmation before execution."
  },
  {
    question: "How do I change the keyboard shortcut?",
    answer: "Currently, ClaudeSpotlight uses ⌘⇧Space (same as Spotlight). Custom keyboard shortcut configuration is planned for version 2.0. You can track this feature on GitHub."
  },
  {
    question: "Is ClaudeSpotlight free?",
    answer: "Yes, ClaudeSpotlight is completely free and open-source under the MIT License. However, you'll need to pay for API usage with your chosen provider (Anthropic, Vertex AI, or AWS Bedrock)."
  },
  {
    question: "Can I use it offline?",
    answer: "No, ClaudeSpotlight requires an internet connection to communicate with Claude AI through the API. Offline mode detection is planned for a future release."
  }
]

export default function FAQ() {
  const [openIndex, setOpenIndex] = useState<number | null>(0)

  return (
    <section id="faq" className="py-12 md:py-16 lg:py-20 px-4 md:px-6">
      <div className="container mx-auto max-w-3xl">
        <div className="text-center mb-10 md:mb-16">
          <h2 className="text-3xl md:text-4xl lg:text-5xl font-bold text-white mb-3 md:mb-4">
            Frequently Asked Questions
          </h2>
          <p className="text-base md:text-lg lg:text-xl text-gray-400 px-4">
            Everything you need to know about ClaudeSpotlight
          </p>
        </div>

        <div className="space-y-3 md:space-y-4">
          {faqs.map((faq, index) => (
            <div 
              key={index}
              className="rounded-xl md:rounded-2xl border border-emerald-500/20 bg-emerald-950/20 overflow-hidden hover:border-emerald-500/40 transition-colors"
            >
              <button
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
                className="w-full px-4 md:px-6 py-3 md:py-4 flex items-center justify-between text-left hover:bg-emerald-900/20 transition-colors"
              >
                <span className="text-sm md:text-base lg:text-lg font-semibold text-white pr-4">
                  {faq.question}
                </span>
                <ChevronDown 
                  className={cn(
                    "w-5 h-5 text-gray-400 transition-transform flex-shrink-0",
                    openIndex === index && "transform rotate-180"
                  )}
                />
              </button>
              
              <div 
                className={cn(
                  "overflow-hidden transition-all duration-300",
                  openIndex === index ? "max-h-96" : "max-h-0"
                )}
              >
                <div className="px-4 md:px-6 pb-3 md:pb-4 text-sm md:text-base text-gray-400 leading-relaxed">
                  {faq.answer}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
