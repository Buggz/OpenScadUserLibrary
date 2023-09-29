PATTERN_CROSSLINES = "crosslines";
PATTERN_HEXAGONAL = "hexagonal";
PATTERN_OCTAGONAL = "octagonal";

//HexagonalPattern(size = [92, 63, 1]);

module Pattern(size, patternType){
    if (patternType == PATTERN_CROSSLINES)
        CrosslinesPattern(size);
    else if (patternType == PATTERN_HEXAGONAL)
        HexagonalPattern(size);
    else if (patternType == PATTERN_OCTAGONAL)
        OctagonalPattern(size);
}

module CrosslinesPattern(size){
    intersection(){
        cube([size.x, size.y, 1]);
        union() {
            for (i = [-size.x : 9 : size.x]) {
                translate(size / 2 + [i, 0, 0]){
                    rotate([0, 0, 30])
                        cube([2, 2 * size.y, size.z], center = true);
                    rotate([0, 0, -30])
                        cube([2, 2 * size.y, size.z], center = true);
                }
            }
        }
    }
}

module HexagonalPattern(size){
    NgonPattern(size = size, diameter = 8, ngonWall = 0, facets = 6, angle = 15, overlap = [1, 0], yOffsetEverySecondColumn = 4);
}

module OctagonalPattern(size){
    NgonPattern(size = size, diameter = 9, ngonWall = 1, facets = 8, angle = 15, overlap = [4.5, 0], yOffsetEverySecondColumn = 4.5);
}

module NgonPattern(size, diameter = 8, ngonWall = 1, facets = 6, angle = 15, overlap = [0, 0], yOffsetEverySecondColumn = 0){
    if (ngonWall == 0){
        difference() {
            cube(size);
            NgonPatternBase(size, diameter, ngonWall, facets, angle, overlap, yOffsetEverySecondColumn);
        }
    } else {
        intersection(){
            cube(size);
            NgonPatternBase(size, diameter, ngonWall, facets, angle, overlap, yOffsetEverySecondColumn);
        }
    }
}

module NgonPatternBase(size, diameter = 8, ngonWall = 1, facets = 6, angle = 15, overlap = [0, 0], yOffsetEverySecondColumn = 0){
    startX = (size.x % (diameter - overlap.x)) / 2;
    startY = (size.y % (diameter - overlap.y)) / 2;
    xDiff = diameter - overlap.x;
    yDiff = diameter - overlap.y;
        for(xIndex = [-3 : size.x / xDiff + 3])
            for (yIndex = [-3 : size.y / yDiff + 3]) {
                yOffset = xIndex % 2 == 0 ? yOffsetEverySecondColumn : 0;
                x = -startX + xIndex * xDiff - overlap.x;
                y = -startY + yIndex * yDiff + yOffset - overlap.y;
                translate([x, y, -1])
                    hollow_ngon(diameter, ngonWall, 3, facets, angle);
            }
}

module hollow_ngon(diameter, wall, height, facets = 7, angle = 0) {
    rotate([0, 0, angle])
        difference(){
            ngon(diameter, height, facets, angle);
            if (wall > 0)
                translate([0, 0, -0.01])
                    ngon(diameter - wall, height + 0.02, facets, angle);
        }
}

module ngon(diameter, height, facets = 7, angle = 0) {
    deg = 360/facets;
    radius = diameter / 2;
    points = [
        for (i = [0 : facets - 1])
            rotate2D([0, radius], deg * i + angle)
    ];
    linear_extrude(height = height) {
        polygon(points);
        }
}

function rotate2D(vector, angle) = [
    vector.x * cos(angle) - vector.y * sin(angle),
    vector.x * sin(angle) + vector.y * cos(angle),
];

