# itmux: a flat, rounded dark theme for tmux (tested with 3.7)
#
# Load it from ~/.config/tmux/tmux.conf with:
#   source-file ~/.config/tmux/itmux/itmux.tmux
#
# Needs a Nerd Font (e.g. Iosevka Nerd Font) for the icons and rounded caps.

# --- Palette -----------------------------------------------------------------
# bar     #1f232d   raised #2a2f3c   border #343a48   faint  #3a4050
# fg      #c8cedb   dim    #6b7387   on     #191c24   select #3d3560
# blue    #8aa4ff   amber  #f0b866   violet #c39bff   coral  #f07a6a   cyan #7fd4d8

# Session pill and active border follow the mode: amber after the prefix,
# violet in copy mode, blue otherwise.
set -g @itmux_mode "#{?client_prefix,#f0b866,#{?pane_in_mode,#c39bff,#8aa4ff}}"
set -gF @itmux_dir "#{d:current_file}"

# --- Status bar --------------------------------------------------------------
set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-style "bg=#1f232d fg=#c8cedb"
set -g status-left-length 40
set -g status-right-length 150

set -g status-left "#[fg=#{E:@itmux_mode} bg=#1f232d]#[fg=#191c24 bg=#{E:@itmux_mode} bold] #S#[fg=#{E:@itmux_mode} bg=#1f232d nobold] "

# Mode chips appear only while they apply, then git, path, CPU and clock.
set -g status-right "\
#{?client_prefix,#[fg=#f0b866]#[fg=#191c24 bg=#f0b866 bold]PREFIX#[fg=#f0b866 bg=#1f232d nobold] ,}\
#{?pane_in_mode,#[fg=#c39bff]#[fg=#191c24 bg=#c39bff bold]COPY#[fg=#c39bff bg=#1f232d nobold] ,}\
#{?synchronize-panes,#[fg=#f07a6a]#[fg=#191c24 bg=#f07a6a bold]SYNC#[fg=#f07a6a bg=#1f232d nobold] ,}\
#(#{@itmux_dir}/scripts/git-branch.sh '#{pane_current_path}')\
#[fg=#8aa4ff] #[fg=#c8cedb]#{s|^$HOME|~|:pane_current_path} #[fg=#3a4050]│ \
#(#{@itmux_dir}/scripts/cpu.sh)\
#[fg=#2a2f3c bg=#1f232d]#[fg=#8aa4ff bg=#2a2f3c] #[fg=#c8cedb]%H:%M #[fg=#6b7387]%a %d %b#[fg=#2a2f3c bg=#1f232d]"

# --- Windows -----------------------------------------------------------------
setw -g monitor-activity on
set -g visual-activity off
set -g window-status-separator ""
setw -g window-status-style "fg=#6b7387 bg=#1f232d"
setw -g window-status-activity-style "none"
setw -g window-status-bell-style "none"

setw -g window-status-format " #[fg=#3a4050]#I #[fg=#6b7387]#W\
#{?window_zoomed_flag, #[fg=#7fd4d8],}\
#{?window_bell_flag, #[fg=#f07a6a]•,#{?window_activity_flag, #[fg=#f0b866]•,}} "

setw -g window-status-current-format "#[fg=#2a2f3c bg=#1f232d]\
#[fg=#8aa4ff bg=#2a2f3c bold]#I #[fg=#c8cedb]#W\
#{?window_zoomed_flag, #[fg=#7fd4d8],}\
#[fg=#2a2f3c bg=#1f232d nobold]"

# --- Panes -------------------------------------------------------------------
set -g pane-border-status top
set -g pane-border-lines single
set -g pane-border-style "#{?synchronize-panes,fg=#f07a6a,fg=#343a48}"
set -g pane-active-border-style "#{?synchronize-panes,fg=#f07a6a,fg=#{E:@itmux_mode}}"
set -g pane-border-format "#{?pane_active,#[fg=#{E:@itmux_mode} bold],#[fg=#6b7387]} #P · #{pane_current_command} "

# --- Copy mode, messages, menus ----------------------------------------------
set -g mode-style "bg=#3d3560 fg=#c8cedb"
set -g copy-mode-position-style "bg=#c39bff fg=#191c24 bold"
set -g message-style "bg=#2a2f3c fg=#c8cedb"
set -g message-command-style "bg=#2a2f3c fg=#8aa4ff"
set -g menu-style "bg=#1f232d fg=#c8cedb"
set -g menu-selected-style "bg=#8aa4ff fg=#191c24 bold"
set -g menu-border-style "fg=#8aa4ff"
set -g menu-border-lines rounded
set -g popup-border-style "fg=#8aa4ff"
set -g popup-border-lines rounded
setw -g clock-mode-colour "#8aa4ff"

# --- Key menu: prefix + Space ------------------------------------------------
# Replaces the default prefix + Space (next-layout), which moves into the menu.
bind Space display-menu -x C -y C -T "#[align=centre fg=#8aa4ff bold] itmux · keys " -- \
  "-#[fg=#6b7387]PANES"     "" "" \
  "Split right"             "|" "split-window -h -c '#{pane_current_path}'" \
  "Split down"              "-" "split-window -v -c '#{pane_current_path}'" \
  "Zoom pane"               z   "resize-pane -Z" \
  "Close pane"              x   "confirm-before -p 'Close pane #P? (y/n)' kill-pane" \
  "Sync panes"              y   "setw synchronize-panes" \
  "Next layout"             Space "next-layout" \
  "" \
  "-#[fg=#6b7387]WINDOWS"   "" "" \
  "New window"              c   "new-window -c '#{pane_current_path}'" \
  "Rename window"           ,   "command-prompt -I '#W' { rename-window '%%' }" \
  "Next window"             n   "next-window" \
  "Previous window"         p   "previous-window" \
  "Choose window"           w   "choose-tree -Zw" \
  "" \
  "-#[fg=#6b7387]SESSION"   "" "" \
  "Copy mode"               [   "copy-mode" \
  "Choose session"          s   "choose-tree -Zs" \
  "Reload config"           r   "source-file ~/.config/tmux/tmux.conf ; display 'Config reloaded'" \
  "Detach"                  d   "detach-client" \
  "List all keys"           ?   "list-keys -N"
