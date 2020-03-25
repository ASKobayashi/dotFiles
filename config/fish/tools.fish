# Use exa
set -gx EXA_COLORS "ur=36:gr=36:tr=36"
set -gx EXA_COLORS "$EXA_COLORS:uw=36:gw=36:tw=36"
set -gx EXA_COLORS "$EXA_COLORS:ux=36:gx=36:tx=36:ue=36"

if type -q -f exa 2>/dev/null
    alias ls="exa -F"
    function l
        exa $arg
    end
    function lt
        exa -laT --git $arg
    end
    function ll
        exa -la --git $arg
    end
    function llm
        exa -lah -s modified --git $arg
    end
    function llt
        exa -la type --git $arg
    end
    function llf
        exa -lahg --modified --accessed --created --git $arg
    end
end

