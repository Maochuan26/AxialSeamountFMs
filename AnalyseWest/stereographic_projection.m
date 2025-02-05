function [x_proj, y_proj] = stereographic_projection(vec)
    if vec(3) < 0
        vec = -vec; % Mirror to northern hemisphere
    end
    x_proj = vec(1) / (1 + vec(3));
    y_proj = vec(2) / (1 + vec(3));
end