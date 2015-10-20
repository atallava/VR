function sources = getSources(G,node)

sources = [];
que = getSucc(G,node);
while ~isempty(que)
    % Pop state.
    state = que(1);
    que(1) = [];
    
    % Detect cycle.
    if state == node
        continue;
    end
    
    % Expand state
    succ = getSucc(G,state);
    
    % Add to sources
    if isempty(succ)
        if ~any(sources == state) && (G(node,state) == 1)
            sources(end+1) = state;
        end
    end
    
    % Update que
    que = [que succ];
end

end

function succ = getSucc(G,node)
succ = find(G(node,:));
end