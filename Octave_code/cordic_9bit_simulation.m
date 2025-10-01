function [cos_out, sin_out] = cordic_9bit_simulation(z0_in)

    atan_table = int32([64, 38, 20, 10, 5, 3, 1, 0]);
    PI_DIV_2 = int32(128);
    K_inv = int32(607);

    z0_in = int32(z0_in);

    % Inicialização (Estado 0)
    quadrant_bits = bitshift(z0_in, -7);
    x=int32(0); y=int32(0); z=int32(0);

    if (quadrant_bits == 0 || quadrant_bits == 3)
        x = K_inv; y = int32(0); z = z0_in;
    elseif (quadrant_bits == 1)
        x = int32(0); y = K_inv; z = z0_in - PI_DIV_2;
    else
        x = int32(0); y = K_inv; z = z0_in + PI_DIV_2;
    end
    z = wrap_signed(z, 9);

    % Laço de Iteração (Estado 1)
    for i = 0:7
        % CORREÇÃO: Garante que dx, dy, dz também são int32
        dx = bitshift(y, -i);
        dy = bitshift(x, -i);
        dz = atan_table(i+1);

        if (z >= 0)
            x = x - dx; y = y + dy; z = z - dz;
        else
            x = x + dx; y = y - dy; z = z + dz;
        end
        x = wrap_signed(x, 11); y = wrap_signed(y, 11); z = wrap_signed(z, 9);
    end

    % Lógica Final
    if (quadrant_bits == 2)
        cos_out = -x; sin_out = -y;
    else
        cos_out = x; sin_out = y;
    end
    cos_out = wrap_signed(cos_out, 11);
    sin_out = wrap_signed(sin_out, 11);

    % Converte a saída final para o tipo int16, como o hardware faria
    cos_out = int16(cos_out);
    sin_out = int16(sin_out);
end

% CORREÇÃO: A função agora opera com int32 e retorna um int32
function wrapped_val = wrap_signed(value, bits)
    min_val = -2^(bits-1); max_val = 2^(bits-1) - 1; range = 2^bits;
    value = int32(value); % Garante que a entrada é int32

    if (value > max_val || value < min_val)
        value = mod(value - min_val, range) + min_val;
    end
    wrapped_val = int32(value);
end
