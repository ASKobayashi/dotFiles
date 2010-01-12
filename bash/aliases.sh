# Aliases 
################################################################### 

# Servers and other shortcuts
alias blueboy='ssh -p23 blueboy.wilpig.org'
alias dirt='ssh ASKobayashi@dirt.homeip.net'
alias kang='ssh specialk@kangaroo.whatbox.ca'
alias challenge='ssh aaron@challengeapp.com'
alias askobayashi='ssh askobayashi@ASKobayashi.com'
alias challengepreview='ssh challengeappask@preview.challengeapp.com'
alias chap='pushd ~/Desktop/Current\ Work/Challenge/Challenge-Rails'
alias railsLog='screen -c ~/.screenrc.rails'
alias shelby='ssh -p 58346 dynamo@4.71.122.214'

# Standard Navigation and File Manipulation
alias cd..='cd ..'
alias cp='cp -i'
alias mv='mv -i'
alias su='su -'
alias pa='ps aux'
alias mroe="less -E"
alias more="less -E"
alias h='history'
alias vi='vim'

# Development Aliases
alias gitx='gitx -c'
alias gs='git status'
alias gl='git log'

# Web Dev Aliases
alias apache2ctl='sudo /opt/local/apache2/bin/apachectl'
alias mysqlstart='sudo /opt/local/bin/mysqld_safe5 &'
alias mysqlstop='/opt/local/bin/mysqladmin5 -u root -p shutdown'

# Other Special stuff
alias clearlicense='
rm -f ~/Library/Caches/.baudburn*.cache && \
rm ~/Library/Preferences/com.macromates.textmate.plist '
alias itunesListen='lsof |grep "iTunes Music"'

# Custom ls functionality
alias ls='~/.bash/ls.sh'
alias ll='ls -lA'
alias la='ls -Ax'

