#version 330 core
layout(location = 0) in vec3 position;
layout(location = 1) in vec4 normal;
layout(location = 2) in vec4 colour;
layout(location = 3) in vec3 texture_position;

out vec4 vertex_colour;
out vec3 vertex_texture_position;

uniform mat4 model;
uniform mat4 view;

uniform mat4 view_model;
uniform mat4 projection_view_model;

// TODO move these to uniform
float light_gradient[] = float[](
    0.992203, 0.984436, 0.976700, 0.968994, 0.961319, 0.953674, 0.946060,
    0.938477, 0.930923, 0.923401, 0.915909, 0.908447, 0.901016, 0.893616,
    0.886246, 0.878906, 0.871597, 0.864319, 0.857071, 0.849854, 0.842667,
    0.835510, 0.828384, 0.821289, 0.814224, 0.807190, 0.800186, 0.793213,
    0.786270, 0.779358, 0.772476, 0.765625, 0.758804, 0.752014, 0.745255,
    0.738525, 0.731827, 0.725159, 0.718521, 0.711914, 0.705338, 0.698792,
    0.692276, 0.685791, 0.679337, 0.672913, 0.666519, 0.660156, 0.653824,
    0.647522, 0.641251, 0.635010, 0.628799, 0.622620, 0.616470, 0.610352,
    0.604263, 0.598206, 0.592178, 0.586182, 0.580215, 0.574280, 0.568375,
    0.562500, 0.556656, 0.550842, 0.545059, 0.539307, 0.533585, 0.527893,
    0.522232, 0.516602, 0.511002, 0.505432, 0.499893, 0.494385, 0.488907,
    0.483459, 0.478043, 0.472656, 0.467300, 0.461975, 0.456680, 0.451416,
    0.446182, 0.440979, 0.435806, 0.430664, 0.425552, 0.420471, 0.415421,
    0.410400, 0.405411, 0.400452, 0.395523, 0.390625, 0.385757, 0.380920,
    0.376114, 0.371338, 0.366592, 0.361877, 0.357193, 0.352539, 0.347916,
    0.343323, 0.338760, 0.334229, 0.329727, 0.325256, 0.320816, 0.316406,
    0.312027, 0.307678, 0.303360, 0.299072, 0.294815, 0.290588, 0.286392,
    0.282227, 0.278091, 0.273987, 0.269913, 0.265869, 0.261856, 0.257874,
    0.253922, 0.250000, 0.246109, 0.242249, 0.238419, 0.234619, 0.230850,
    0.227112, 0.223404, 0.219727, 0.216080, 0.212463, 0.208878, 0.205322,
    0.201797, 0.198303, 0.194839, 0.191406, 0.188004, 0.184631, 0.181290,
    0.177979, 0.174698, 0.171448, 0.168228, 0.165039, 0.161880, 0.158752,
    0.155655, 0.152588, 0.149551, 0.146545, 0.143570, 0.140625, 0.137711,
    0.134827, 0.131973, 0.129150, 0.126358, 0.123596, 0.120865, 0.118164,
    0.115494, 0.112854, 0.110245, 0.107666, 0.105118, 0.102600, 0.100113,
    0.097656, 0.095230, 0.092834, 0.090469, 0.088135, 0.085831, 0.083557,
    0.081314, 0.079102, 0.076920, 0.074768, 0.072647, 0.070557, 0.068497,
    0.066467, 0.064468, 0.062500, 0.060562, 0.058655, 0.056778, 0.054932,
    0.053116, 0.051331, 0.049576, 0.047852, 0.046158, 0.044495, 0.042862,
    0.041260, 0.039688, 0.038147, 0.036636, 0.035156, 0.033707, 0.032288,
    0.030899, 0.029541, 0.028214, 0.026917, 0.025650, 0.024414, 0.023209,
    0.022034, 0.020889, 0.019775, 0.018692, 0.017639, 0.016617, 0.015625,
    0.014664, 0.013733, 0.012833, 0.011963, 0.011124, 0.010315, 0.009537,
    0.008789, 0.008072, 0.007385, 0.006729, 0.006104, 0.005508, 0.004944,
    0.004410, 0.003906, 0.003433, 0.002991, 0.002579, 0.002197, 0.001846,
    0.001526, 0.001236, 0.000977, 0.000748, 0.000549, 0.000381, 0.000244,
    0.000137, 0.000061, 0.000015, 0.000000);

float texture_light_gradient[] = float[](
    0.972549, 0.972549, 0.972549, 0.972549, 0.972549, 0.972549, 0.972549,
    0.972549, 0.972549, 0.972549, 0.972549, 0.972549, 0.972549, 0.972549,
    0.972549, 0.972549, 0.847059, 0.847059, 0.847059, 0.847059, 0.847059,
    0.847059, 0.847059, 0.847059, 0.847059, 0.847059, 0.847059, 0.847059,
    0.847059, 0.847059, 0.847059, 0.847059, 0.721569, 0.721569, 0.721569,
    0.721569, 0.721569, 0.721569, 0.721569, 0.721569, 0.721569, 0.721569,
    0.721569, 0.721569, 0.721569, 0.721569, 0.721569, 0.721569, 0.596078,
    0.596078, 0.596078, 0.596078, 0.596078, 0.596078, 0.596078, 0.596078,
    0.596078, 0.596078, 0.596078, 0.596078, 0.596078, 0.596078, 0.596078,
    0.596078, 0.486275, 0.486275, 0.486275, 0.486275, 0.486275, 0.486275,
    0.486275, 0.486275, 0.486275, 0.486275, 0.486275, 0.486275, 0.486275,
    0.486275, 0.486275, 0.486275, 0.423529, 0.423529, 0.423529, 0.423529,
    0.423529, 0.423529, 0.423529, 0.423529, 0.423529, 0.423529, 0.423529,
    0.423529, 0.423529, 0.423529, 0.423529, 0.423529, 0.360784, 0.360784,
    0.360784, 0.360784, 0.360784, 0.360784, 0.360784, 0.360784, 0.360784,
    0.360784, 0.360784, 0.360784, 0.360784, 0.360784, 0.360784, 0.360784,
    0.298039, 0.298039, 0.298039, 0.298039, 0.298039, 0.298039, 0.298039,
    0.298039, 0.298039, 0.298039, 0.298039, 0.298039, 0.298039, 0.298039,
    0.298039, 0.298039, 0.243137, 0.243137, 0.243137, 0.243137, 0.243137,
    0.243137, 0.243137, 0.243137, 0.243137, 0.243137, 0.243137, 0.243137,
    0.243137, 0.243137, 0.243137, 0.243137, 0.211765, 0.211765, 0.211765,
    0.211765, 0.211765, 0.211765, 0.211765, 0.211765, 0.211765, 0.211765,
    0.211765, 0.211765, 0.211765, 0.211765, 0.211765, 0.211765, 0.180392,
    0.180392, 0.180392, 0.180392, 0.180392, 0.180392, 0.180392, 0.180392,
    0.180392, 0.180392, 0.180392, 0.180392, 0.180392, 0.180392, 0.180392,
    0.180392, 0.149020, 0.149020, 0.149020, 0.149020, 0.149020, 0.149020,
    0.149020, 0.149020, 0.149020, 0.149020, 0.149020, 0.149020, 0.149020,
    0.149020, 0.149020, 0.149020, 0.121569, 0.121569, 0.121569, 0.121569,
    0.121569, 0.121569, 0.121569, 0.121569, 0.121569, 0.121569, 0.121569,
    0.121569, 0.121569, 0.121569, 0.121569, 0.121569, 0.105882, 0.105882,
    0.105882, 0.105882, 0.105882, 0.105882, 0.105882, 0.105882, 0.105882,
    0.105882, 0.105882, 0.105882, 0.105882, 0.105882, 0.105882, 0.105882,
    0.090196, 0.090196, 0.090196, 0.090196, 0.090196, 0.090196, 0.090196,
    0.090196, 0.090196, 0.090196, 0.090196, 0.090196, 0.090196, 0.090196,
    0.090196, 0.090196, 0.074510, 0.074510, 0.074510, 0.074510, 0.074510,
    0.074510, 0.074510, 0.074510, 0.074510, 0.074510, 0.074510, 0.074510,
    0.074510, 0.074510, 0.074510, 0.074510);

uniform int light_ambience;
uniform vec3 light_direction;
uniform int light_diffuse;
uniform int light_direction_magnitude;

void main() {
    int intensity = int(normal.w);

    if (intensity == -256) {
        vec3 model_normal = vec3(model * vec4(vec3(normal), 0.0));
        int divisor = (light_diffuse * light_direction_magnitude) / 256;

        intensity = (int(model_normal.x * 1000) * int(light_direction.x * 1000) +
                       int(model_normal.y * 1000) * int(light_direction.y * 1000) +
                       int(model_normal.z * 1000) * int(light_direction.z * 1000)) /
                      divisor;
    }

    vec3 view_model_normal = vec3(view_model * vec4(vec3(normal), 0.0));
    vec4 view_model_position = view_model * vec4(position, 1.0);

    float visibility = view_model_position.x * view_model_normal.x +
                 view_model_position.y * view_model_normal.y +
                 view_model_position.z * view_model_normal.z;

    int gradient_index = 0;

    if (visibility > 0) {
        gradient_index = light_ambience + intensity;
    } else {
        gradient_index = light_ambience - intensity;
    }

    if (gradient_index > 255) {
        gradient_index = 255;
    } else if (gradient_index < 0) {
        gradient_index = 0;
    }

    float lightness = 1;

    if (texture_position.z > -1) {
        lightness = texture_light_gradient[gradient_index];
    } else {
        lightness = light_gradient[gradient_index];
    }

    gl_Position = projection_view_model * vec4(position, 1.0);

    vertex_colour = vec4(vec3(colour) * lightness, colour.w);
    vertex_texture_position = texture_position;

    // test_normal = mat3(transpose(inverse(model))) * normal;

    /*if (gl_Position.z > (2500.0f / 1000.0f)) {
        vertex_colour = vec4(0, 0, 0, 1);
    }*/
}