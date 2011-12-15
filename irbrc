%w[rubygems wirble ap hirb].each do |gem|
    begin
      require gem
    rescue LoadError => err
      warn "Please do: gem install #{gem.sub(/\/.*/,'')}"
    end
end

IRB.conf[:SAVE_HISTORY] = 50
Wirble.init
Wirble.colorize


