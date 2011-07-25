%w[rubygems wirble ap hirb].each do |gem|
    begin
      require gem
    rescue LoadError => err
      warn "Please do: gem install #{gem.sub(/\/.*/,'')}"
    end
end

Wirble::History::DEFAULTS[:history_uniq] = 'reverse'
Wirble.init
Wirble.colorize


