
CURVE_LENGTH = 10;

DEFAULT_AMPLITUDE = 1;
DEFAULT_PERIOD = 1;
DEFAULT_PHASE_SHIFT = 0;
DEFAULT_VERTICAL_SHIFT = 0;
DEFAULT_LENGTH = 10;
DEFAULT_PRECISION = 36;

function sinusoid_points(
    amplitude = DEFAULT_AMPLITUDE,
    period = DEFAULT_PERIOD,
    phase_shift = DEFAULT_PHASE_SHIFT,
    vertical_shift = DEFAULT_VERTICAL_SHIFT,
    length = DEFAULT_LENGTH,
    precision = DEFAULT_PRECISION
    ) = 
    [ for (x = [0 : length / precision : length])
        [x, amplitude * sin(period * ((360 * x / CURVE_LENGTH) - phase_shift*360)) + vertical_shift]
    ];

module sinusoid(
    amplitude = DEFAULT_AMPLITUDE,
    period = DEFAULT_PERIOD,
    phase_shift = DEFAULT_PHASE_SHIFT,
    vertical_shift = DEFAULT_VERTICAL_SHIFT,
    length = DEFAULT_LENGTH,
    precision = DEFAULT_PRECISION
    ) {
        points = concat(
            [[0,0]],
            sinusoid_points(
                amplitude,
                period,
                phase_shift,
                vertical_shift,
                length,
                precision
            ),
            [[length, 0]]
        );
        echo(points);
        polygon(points);
}
