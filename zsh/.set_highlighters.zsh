# Order matters; keep gradient last so it overrides base colors
ZSH_HIGHLIGHT_HIGHLIGHTERS=(gradient)

# Patterns that should stay with a fixed style (not gradient)
typeset -A ZSH_HIGHLIGHT_PATTERNS
# ZSH_HIGHLIGHT_PATTERNS+=("rm -rf" "bold,fg=red")
# ZSH_HIGHLIGHT_PATTERNS+=("git" "bold,fg=cyan")

# Gradient configuration: tokens
ZSH_HIGHLIGHT_GRADIENT_TOKENS=(sudo git "rm -rf")

# Enable pastel mode (smooth, close-knit colors for short text; expands with length)
ZSH_HIGHLIGHT_GRADIENT_MODE=pastel
# Choose a cool base hue family (teal/cyan region)
ZSH_HIGHLIGHT_GRADIENT_BASE_HUE=190
# Pastel saturation/lightness
ZSH_HIGHLIGHT_GRADIENT_PASTEL_SAT=0.65
ZSH_HIGHLIGHT_GRADIENT_PASTEL_LIGHT=0.75
# Keep short spans tight, then grow smoothly
ZSH_HIGHLIGHT_GRADIENT_BASE_SPAN_DEG=8
ZSH_HIGHLIGHT_GRADIENT_PER_CHAR_SPAN_DEG=4
ZSH_HIGHLIGHT_GRADIENT_MAX_SPAN_DEG=100

# Whole-word matches only; case sensitive
ZSH_HIGHLIGHT_GRADIENT_WORD_BOUNDARY=off
ZSH_HIGHLIGHT_GRADIENT_IGNORE_CASE=off
ZSH_HIGHLIGHT_GRADIENT_ALL=on

# Optional: switch to palette mode by uncommenting the next lines
# ZSH_HIGHLIGHT_GRADIENT_MODE=palette
# ZSH_HIGHLIGHT_GRADIENT_PALETTE=(120 121 122 151 152 159 153 117 111 110)

# Load the highlighters after the config is set
source /Users/mlem/personal/projects/zsh-syntax-highlighting-gradient/zsh-syntax-highlighting.zsh
