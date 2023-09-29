include <fontmetrics.scad>;
include <Patterns.scad>;

DEFAULT_FONT = "Liberation Sans";
LATIN_FONT = "Symbola:style=Regular";

$fn = $preview ? 20 : 100;

module lid(size, wall_thickness = 1.5, pattern_type = PATTERN_CROSSLINES, caption = "", caption_height = 10, caption_rotation = 0, caption_font = "Liberation Sans", caption_padding = [0, 0]) {
    lid_base(size, wall_thickness);
    PatternWithCaption([size.x, size.y, 1], pattern_type, caption, caption_height, caption_rotation, caption_font, [caption_padding.x, caption_padding.y, 0]);
    notches(size, wall_thickness);
}

module lid_base(size, wall_thickness) {
    difference() {
        cube([size.x, size.y, size.z]);
        translate([wall_thickness, wall_thickness, -wall_thickness])
            cube([size.x - 2 * wall_thickness, size.y - 2 * wall_thickness, size.z + 2 * wall_thickness]);
    }
}

module PatternWithCaption(size, type, caption = "", caption_height, caption_rotation, caption_font, caption_padding) {
    if (!caption) {
        Pattern(size, type);
    } else {
        caption_length = measureText(caption, size = caption_height);
        caption_size = [caption_length + 6, caption_height * 1.4, 1] + caption_padding;
        union(){
            difference(){
                Pattern(size, type);
                translate([size.x / 2, size.y / 2, caption_size.z / 2])
                    rotate([0, 0, caption_rotation])
                        plaque(caption_size, center = true);
            }
            translate([size.x / 2, size.y / 2, caption_size.z / 2]) {
                difference(){
                    rotate([0, 0, caption_rotation])
                        plaque(caption_size, center = true);
                    rotate([0, 180, caption_rotation])
                        linear_extrude(0.5)
                            text(caption, caption_height, halign = "center", valign = "center", font = caption_font);
                }
            }
        }
    }
}

module plaque(size, radius = 1, center = false){
    diff = center ? size / 2 : [0,0,0];
    hull(){
        for (x = [radius, size.x - radius])
            for (y = [radius, size.y - radius])
                translate([x, y, 0] - diff)
                    cylinder(size.z, r = radius);
    }
}

module roundedCube(size, radius, center = false){
    diff = center ? size / 2 : [0,0,0];
    hull(){
        for (x = [radius, size.x - radius])
            for (y = [radius, size.y - radius])
               for (z = [radius, size.z - radius])
                    translate([x, y, z] - diff)
                        sphere(radius);
    }
}

module notches(size, wall_thickness){
    dist_from_edge = 2 + wall_thickness;
    capsule_length = 5;
    capsule_roundness = 0.5;
    
    diff = wall_thickness + capsule_length / 2 + 3;
    for (x = [diff, size.x - diff]) {
        for (y = [wall_thickness, size.y - wall_thickness]){
            translate([x, y, size.z - 2])
                roundedCube([capsule_length, 1, 2], capsule_roundness, true);
        }
    }
    for (x = [wall_thickness, size.x - wall_thickness]) {
        for (y = [diff, size.y - diff]){
            translate([x, y, size.z - 2])
                roundedCube([1, capsule_length, 2], capsule_roundness, true);
        }
    }
}