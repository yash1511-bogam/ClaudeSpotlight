# Deployment Guide

This document explains how to set up CI/CD pipelines and deploy the ClaudeSpotlight project.

## Table of Contents

- [Project Structure](#project-structure)
- [macOS App Deployment](#macos-app-deployment)
- [Website Deployment](#website-deployment)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Vercel Setup](#vercel-setup)

## Project Structure

```
ClaudeSpotlight/
├── Sources/              # macOS app source code (Swift)
├── website/             # Next.js website
├── .github/workflows/   # CI/CD workflows
└── vercel.json         # Vercel configuration
```

## macOS App Deployment

### Automated Workflows

The macOS app has the following automated workflows:

1. **CI Workflow** (`ci.yml`) - Runs on every push/PR (excluding website changes)
   - Builds with Swift Package Manager
   - Builds with Xcode
   - Creates .app bundle
   - Runs tests and static analysis

2. **CD Workflow** (`cd.yml`) - Deploys development builds
   - Triggers on push to master/main
   - Creates development .zip archive
   - Publishes to `dev-latest` GitHub release

3. **Release Workflow** (`release.yml`) - Production releases
   - Triggers on version tags (v1.0.0, v1.1.0, etc.)
   - Creates .dmg installer
   - Creates .zip archive
   - Generates SHA-256 checksums
   - Publishes GitHub release with notes

4. **PR Checks** (`pr-checks.yml`) - Validates pull requests
   - Syntax validation
   - Build verification
   - Binary size reporting
   - Security scanning

### Manual Release Process

To create a new release:

```bash
# 1. Update version in appropriate files
# 2. Commit changes
git add .
git commit -m "Release v1.0.0"

# 3. Create and push tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# 4. GitHub Actions will automatically:
#    - Build the app
#    - Create DMG and ZIP
#    - Publish GitHub release
```

## Website Deployment

The website is a Next.js application deployed to Vercel with automated CI/CD.

### Automated Workflows

1. **Website CI** (`website-ci.yml`) - Runs on website changes
   - Lints code
   - Type checks
   - Builds Next.js app
   - Analyzes bundle size

2. **Website CD** (`website-cd.yml`) - Deploys to Vercel
   - **Preview deployments**: On non-main branches
   - **Production deployments**: On master/main branch
   - Comments deployment URLs on commits

### Vercel Configuration

The `vercel.json` file ensures only the website folder is deployed:

```json
{
  "version": 2,
  "buildCommand": "cd website && npm install && npm run build",
  "devCommand": "cd website && npm run dev",
  "framework": "nextjs",
  "outputDirectory": "website/.next"
}
```

## GitHub Actions Workflows

### Workflow Isolation

The workflows are configured to run independently:

- **App workflows** ignore `website/**` changes
- **Website workflows** only trigger on `website/**` changes
- This prevents unnecessary builds and saves CI/CD minutes

### Workflow Triggers

| Workflow | Trigger | Paths |
|----------|---------|-------|
| CI | Push/PR to master | All except website/ |
| CD | Push to master | All except website/ |
| Release | Tag push (v*) | N/A |
| PR Checks | Pull requests | All except website/ |
| Website CI | Push/PR to master | website/** only |
| Website CD | Push to master | website/** only |

## Vercel Setup

### Prerequisites

1. Vercel account at [vercel.com](https://vercel.com)
2. GitHub repository connected to Vercel
3. Required secrets in GitHub repository settings

### Step 1: Connect Repository to Vercel

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Click "Add New Project"
3. Import your GitHub repository
4. **Important**: Configure root directory to `website`

### Step 2: Configure Vercel Project

In Vercel project settings:

1. **Root Directory**: `website`
2. **Framework Preset**: Next.js
3. **Build Command**: `npm run build`
4. **Output Directory**: `.next`
5. **Install Command**: `npm ci`

### Step 3: Get Vercel Credentials

Get your Vercel credentials for GitHub Actions:

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Link to your project (from website/ directory)
cd website
vercel link

# Get your credentials
cat .vercel/project.json
```

This will show:
```json
{
  "orgId": "team_xxxxxxxxxxxxx",
  "projectId": "prj_xxxxxxxxxxxxx"
}
```

### Step 4: Create Vercel Token

1. Go to [Vercel Account Settings → Tokens](https://vercel.com/account/tokens)
2. Create a new token with a descriptive name (e.g., "GitHub Actions")
3. Copy the token (you won't see it again!)

### Step 5: Add GitHub Secrets

Add these secrets to your GitHub repository:

1. Go to repository **Settings → Secrets and variables → Actions**
2. Click **"New repository secret"**
3. Add the following secrets:

| Secret Name | Value | Where to Find |
|------------|-------|---------------|
| `VERCEL_TOKEN` | Your Vercel token | Created in Step 4 |
| `VERCEL_ORG_ID` | Your org/team ID | From `project.json` (orgId) |
| `VERCEL_PROJECT_ID` | Your project ID | From `project.json` (projectId) |

### Step 6: Test Deployment

Push a change to the website folder:

```bash
# Make a change to the website
cd website
echo "// test" >> app/page.tsx

# Commit and push
git add .
git commit -m "Test website deployment"
git push origin master

# Check GitHub Actions
# The website-cd.yml workflow should trigger
# Check Vercel dashboard for deployment
```

### Step 7: Verify Deployment

1. Check GitHub Actions tab for workflow run
2. Check Vercel dashboard for deployment status
3. Look for deployment URL comment on your commit

## Deployment URLs

After setup, you'll have:

- **Production**: `https://your-project.vercel.app`
- **Preview**: Automatic preview URLs for non-main branches
- **App Releases**: GitHub Releases page

## Troubleshooting

### Website deployment fails

1. **Check secrets**: Verify VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID
2. **Check root directory**: Must be set to `website` in Vercel
3. **Check build logs**: Look at GitHub Actions and Vercel logs
4. **Verify token**: Token might have expired, create a new one

### App build fails

1. **Check Xcode version**: Requires Xcode 16.0+
2. **Check macOS version**: Requires macOS 15.0+
3. **Check dependencies**: Run `swift package resolve`
4. **Check entitlements**: Verify signing certificates

### Workflow not triggering

1. **Check path filters**: Ensure your changes match workflow paths
2. **Check branch**: Some workflows only run on master/main
3. **Check workflow file**: Verify YAML syntax is correct

## Environment Variables

### Website (Vercel)

Set these in Vercel dashboard if needed:

- `NODE_ENV`: production (auto-set)
- `NEXT_PUBLIC_*`: Any public environment variables

### macOS App

Set these locally:

- `ANTHROPIC_API_KEY`: Your Claude API key

## Security Notes

1. **Never commit secrets** to the repository
2. **Use GitHub Secrets** for sensitive data
3. **Rotate tokens** periodically
4. **Review permissions** on Vercel tokens
5. **Monitor deployments** for unexpected changes

## Support

For issues:

1. Check GitHub Actions logs
2. Check Vercel deployment logs
3. Review this deployment guide
4. Create an issue on GitHub with relevant logs

---

**Last Updated**: 2024
**Maintained by**: ClaudeSpotlight Team
