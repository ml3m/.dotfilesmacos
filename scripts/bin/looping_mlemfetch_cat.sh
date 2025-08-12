#!/usr/bin/env bash
# animate_cat.sh - loop a 4-frame ASCII cat animation
# Usage: ./animate_cat.sh [delay_seconds] [loops]
# delay_seconds: default 0.15
# loops: 0 = infinite (default), or number of times to cycle

set -euo pipefail

delay=${1:-0.30}
loops=${2:-0}

cleanup() {
  tput cnorm 2>/dev/null || true
  printf '\n' >/dev/tty
}
trap cleanup EXIT INT TERM

# Hide cursor
tput civis 2>/dev/null || true

frames=()

## (head)
#frames+=("$(cat <<'FRAME'
#                               
#                               
#
#        _                        
#        \`*,.                   
#        /  _ `-.                 
#       .  : `, `.                
#       ; _   '  |               
#       / *` _,   `*-._          
#       `-`,'          `-.       
#         :.              \    
#         . \      `   .-. .   
#         '  ._ ;  ;  '     :   
#         :  , `|  ,  ;      ;-.
#         ; '   : ;`-:    _.`*  ;
#[bug] .*' /  .*' ; .*`- +'  `*' 
#      `*-*   `*-*  `*-*'       
#FRAME
#)")


# frame 1 (air in)
frames+=("$(cat <<'FRAME'
                               

       _                        
       \`*-.                    
        )  _`-.                 
       .  : `. .                
       : _   '  \               
       ; *` _.   `*-._          
       `-.-'          `-.       
         ;       `       `.     
         :.       .        \    
         . \  .   :   .-'   .   
         '  `+.;  ;  '      :   
         :  '  |  ,  ;       ;-.
         ; '   : :`-:     _.`*  ;
[bug] .*' /  .*' ; .*`- +'  `*'*
      `*-*   `*-*  `*-*'       
FRAME
)")

# frame 2 (air out)
frames+=("$(cat <<'FRAME'
                               
                               

       _                        
       \`*-.                    
        )  _`-.                 
       .  : `. .                
       : _   '  \               
       / *` _.   `*-._          
       `-.-'          `-.       
         :.              \    
         . \      `   .-. .   
         '  ._ ;  ;  '     :   
         :  , `|  ,  ;      ;-.
         ; '   : :`-:    _.`*  ;
[bug] .*' /  .*' ; .*`- +'  `*' 
      `*-*   `*-*  `*-*'       
FRAME
)")


# frame 3 (paw)
frames+=("$(cat <<'FRAME'
                               
                               

        _                        
        \`*,.                   
        /  _ `-.                 
       .  : `, `.                
       ; _   '  |               
       / *` _,   `*-._          
       `-`,'          `-.       
         : .             \    
         ; ;      `   .-. .   
        , ; \_ ;  ;  '     :   
    .*'` /    `|  ,  ;      ;-.
    `*-'`      ; :`-:    _.`*  ;
[bug]        .*' ; .*`- +`  `*' 
             `*-*  `*-*'       
FRAME
)")

# frame 4 (bug to mouth 1)
frames+=("$(cat <<'FRAME'
                               
                               

        _                        
        \`*,.                   
        /  _ `-.                 
       .  : `, `.                
       ; _   '  |               
       / *` _,   `*-._          
       `-`,'          `-.       
         : .             \    
         ; ;      `   .-. .   
 [bug]  , ; \_ ;  ;  '     :   
    .*'` /    `|  ,  ;      ;-.
    `*-'`      ; :`-:    _.`*  ;
             .*' ; .*`- +`  `*' 
             `*-*  `*-*'       
FRAME
)")

# frame 5 (bug to mouth 2)
frames+=("$(cat <<'FRAME'
                               
                               

        _                        
        \`*,.                   
        /  _ `-.                 
       .  : `, `.                
       ; _   '  |               
       / *` _,   `*-._          
       `-`,'          `-.       
         : .             \    
   [bug], ,;      `   .-. .   
    ,-'` /  `. ;  ;  '     :   
    `*-'`     `|  ,  ;      ;-.
               ; :`-:    _.`*  ;
             .*' ; .*`- +`  `*' 
             `*-*  `*-*'       
FRAME
)")

# frame 6 (bug to mouth 3)
frames+=("$(cat <<'FRAME'
                               
                               

        _                        
        \`*,.                   
        /  _ `-.                 
       .  : `, `.                
       ; _   '  |               
       / *` _,   `*-._          
       `-`,'          `-.       
    [bug]: ,             \    
    ;`'` /,;      `   .-. .   
    `*-'`   `. ;  ;  '     :   
              `|  ,  ;      ;-.
               ; :`-:    _.`*  ;
             .*' ; .*`- +`  `*' 
             `*-*  `*-*'       
FRAME
)")

## frame 7 (bug to mouth 4 - Ate 1)
#frames+=("$(cat <<'FRAME'
#                               
#                               
#
#        _                        
#        \`*,.                   
#        /  _ `-.                 
#       .  : `, `.                
#       ; _   '  |               
#       / *` _,   `*-._          
#       `-`,'          `-.       
#         : .             \    
#        , ,;      `   .-. .   
#    ,-'` /  `. ;  ;  '     :   
#    `*-'`     `|  ,  ;      ;-.
#               ; :`-:    _.`*  ;
#             .*' ; .*`- +`  `*' 
#             `*-*  `*-*'       
#FRAME
#)")

# frame 8 (bug to mouth 2)
frames+=("$(cat <<'FRAME'
                               
                               

        _                        
        \`*,.                   
        /  _ `-.                 
       .  : `, `.                
       ; _   '  |               
       / *` _,   `*-._          
       `-`,'          `-.       
         : .             \    
         ; ;      `   .-. .   
        , ; \_ ;  ;  '     :   
    .*'` /    `|  ,  ;      ;-.
    `*-'`      ; :`-:    _.`*  ;
             .*' ; .*`- +`  `*' 
             `*-*  `*-*'       
FRAME
)")


frame_count=${#frames[@]}

# run animation
i=0
cycle=0

while :; do
  # if loops > 0 and we've finished requested cycles, stop
  if [[ $loops -gt 0 && $cycle -ge $loops ]]; then
    break
  fi

  printf '\033[H\033[2J'  # clear screen / move cursor home
  printf '%s\n' "${frames[i]}"

  # shorter delay for bug motion.
  if [[ $i -eq 2 || $i -eq 3 || $i -eq 4 || $i -eq 5 || $i -eq 6 || $i -eq 7 ]]; then
    sleep 0.15
  else
    sleep "$delay"
  fi

  i=$(( (i + 1) % frame_count ))
  if [[ $i -eq 0 ]]; then
    cycle=$((cycle + 1))
  fi
done

# cleanup trap will restore cursor
