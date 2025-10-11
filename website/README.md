# ClaudeSpotlight Website

Modern, lightweight website for ClaudeSpotlight built with Next.js 14, TypeScript, Tailwind CSS, and shadcn/ui.

## Features

- ⚡ Next.js 14 with App Router
- 🎨 Tailwind CSS for styling
- 🧩 shadcn/ui components
- 📦 Bun package manager
- 📱 Fully responsive design (mobile, tablet, desktop)
- 🌑 Black background (#000000) theme
- ⌨️ JetBrains Mono terminal font
- 🎨 Emerald/Cyan color scheme
- ✨ Modern and lightweight

## Getting Started

### Prerequisites

- [Bun](https://bun.sh) installed on your system
- macOS, Linux, or Windows

### Installation

1. Navigate to the website directory:
```bash
cd website
```

2. Install dependencies:
```bash
bun install
```

### Development

Run the development server:

```bash
bun dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build

Create an optimized production build:

```bash
bun run build
```

### Start Production Server

After building, start the production server:

```bash
bun start
```

## Project Structure

```
website/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Home page
│   └── globals.css         # Global styles
├── components/
│   ├── Header.tsx          # Navigation header
│   ├── Hero.tsx            # Hero section
│   ├── Features.tsx        # Features showcase
│   ├── FAQ.tsx             # FAQ accordion
│   ├── Footer.tsx          # Footer with links
│   └── ui/
│       └── button.tsx      # Button component
├── lib/
│   └── utils.ts            # Utility functions
└── public/                 # Static assets
```

## Components

### Separate Components Architecture

The website is built with modular, reusable components:

- **Header**: Fixed navigation with logo, links, and CTA button
- **Hero**: Landing section with headline, description, and action buttons
- **Features**: Grid showcase of 8 key features with icons
- **FAQ**: Expandable accordion with 8 common questions
- **Footer**: Links, social icons, and copyright info

### Styling

- Black background (#000000) throughout
- Terminal-inspired color scheme (emerald green to cyan)
- JetBrains Mono font for authentic terminal aesthetic
- Glass morphism effects with backdrop blur
- Smooth hover transitions
- Fully responsive design:
  - Mobile (320px+): Optimized layouts, smaller text, stacked buttons
  - Tablet (768px+): Adjusted spacing, medium text sizes
  - Desktop (1024px+): Full layouts, large text, side-by-side elements
- Adaptive font sizes and spacing across breakpoints
- Touch-friendly button sizes on mobile

## Tech Stack

- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: shadcn/ui
- **Icons**: Lucide React
- **Package Manager**: Bun

## License

MIT License - Same as ClaudeSpotlight
