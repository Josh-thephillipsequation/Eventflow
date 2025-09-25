---
ai.include_by_default: false
ai.weight: 0.1
---

# Agents Documentation Structure

## Overview

This directory contains specialized agent documentation organized for efficient context management. Each file targets specific agent needs and capabilities.

## Profile-Based Documentation

### Default Profile (Always Included)
- **agents/core.md** - Essential project info, commands, patterns
- **agents/development.md** - Active development context and priorities
- **agents/architecture.md** - Codebase structure and design principles

### Specialized Profiles
- **debugging**: agents/troubleshooting.md + agent_assets/troubleshooting.md
- **testing**: agents/testing.md + CI-specific context
- **deployment**: agents/deployment.md + App Store automation
- **features**: agents/features.md + UI/UX patterns

## Documentation Hierarchy

### 🎯 **Primary Context** (agents/)
**Token Budget: ~3,000 tokens**
- Core development patterns
- Current priorities and blockers
- Essential commands and workflows

### 📋 **Reference Context** (agent_assets/)
**Token Budget: ~2,000 tokens on-demand**
- Detailed technical knowledge
- Historical lessons and troubleshooting
- Complete specifications and checklists

### 🔄 **Dynamic Context** (signals/)
**Token Budget: ~1,000 tokens**
- Real-time CI feedback
- Current test failures and issues
- Build status and alerts

### 📝 **Templates** (templates/)
**Token Budget: As needed**
- Code generation templates
- Documentation templates
- Workflow templates

## Usage Guidelines

### For Standard Development
```
Include by default:
- agents/core.md (project essentials)
- agents/development.md (current priorities)
- AGENTS_TLDR.md (quick reference)
- signals/AGENT_FEEDBACK.md (current issues)
```

### For Debugging Sessions
```
Profile: debugging
Additional context:
- agents/troubleshooting.md
- agent_assets/troubleshooting.md
- Recent CI logs and error signals
```

### For Testing Work
```
Profile: testing
Additional context:
- agents/testing.md
- Test failure analysis
- Coverage reports
```

### For App Store Deployment
```
Profile: deployment
Additional context:
- agents/deployment.md
- agent_assets/app-store-action-plan.md
- iOS build configurations
```

## File Organization Strategy

### Why This Structure Works
1. **Reduced Context Bloat**: Essential info always available, details on-demand
2. **Profile-Specific Loading**: Only include relevant expertise for current task
3. **Real-Time Signals**: Dynamic feedback without manual updates
4. **Template Reuse**: Consistent patterns across development cycles

### Token Budget Management
- **Core Context**: 6,000 tokens (always loaded)
- **Profile Context**: 3,000 tokens (task-specific)
- **Signal Context**: 1,000 tokens (real-time status)
- **Template Context**: Variable (generation-specific)

## Front Matter Usage

### Standard Tags
```yaml
ai.include_by_default: true|false  # Auto-include in agent context
ai.weight: 0.1-1.0                # Priority ranking for inclusion
ai.profiles: [debugging, testing]  # When to include based on agent task
ai.token_budget: 500               # Approximate token count
```

### Profile Definitions
- **debugging**: Troubleshooting, error analysis, CI failures
- **testing**: Test development, coverage analysis, QA workflows
- **deployment**: Build automation, App Store, release management
- **features**: New feature development, UI/UX work

## Integration with Development Workflow

### Handoff Process
1. **AGENTS_TLDR.md**: Quick orientation and current status
2. **agents/core.md**: Essential project knowledge
3. **agents/development.md**: Current priorities and next steps
4. **signals/AGENT_FEEDBACK.md**: Specific issues to address

### During Development
1. **Dynamic signals** provide real-time feedback
2. **Profile-specific docs** load based on current task type
3. **Templates** guide consistent code generation
4. **Reference docs** available on-demand for deep dives

### Quality Gates
1. **validate_handoff.sh**: Ensures documentation completeness
2. **CI feedback loop**: Updates signals automatically
3. **Token budget alerts**: Prevents context overload

## Migration Notes

### From Original AGENTS.md
- Core patterns → agents/core.md
- Development commands → agents/development.md
- Architecture overview → agents/architecture.md
- Troubleshooting → agents/troubleshooting.md

### Benefits of New Structure
- **90% context reduction** for typical tasks
- **Profile-specific expertise** loading
- **Real-time signal integration**
- **Consistent template usage**

## Quick Reference

### Essential Files for Any Agent
1. **AGENTS_TLDR.md** - Project overview and current status
2. **agents/core.md** - Core patterns and commands
3. **agents/development.md** - Current priorities
4. **signals/AGENT_FEEDBACK.md** - Current issues

### When to Include More Context
- **Complex debugging**: Add troubleshooting profile
- **New feature work**: Add features profile
- **CI/Testing issues**: Add testing profile
- **App Store work**: Add deployment profile

### File Locations Quick Reference
- **agents/**: Core agent documentation (3K tokens)
- **agent_assets/**: Reference documentation (on-demand)
- **signals/**: Real-time status (1K tokens)
- **templates/**: Code generation (as-needed)

---

**This structure enables efficient, context-aware agent handoffs while maintaining comprehensive project knowledge.**
