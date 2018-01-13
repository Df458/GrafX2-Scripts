--Zoom in Place v1.0 (Hugues Ross)
-- Scales an image layer-by-layer, and places the 
-- result next to the originall

-- Please direct all feedback, bug reports, and feature requests to
-- hugues.ross@gmail.com, and put the title of this script in the subject line.
-- Satisfaction guaranteed, or your (nonexistant) money back.

-- Note: The memory library is optional. If you don't have it, just replace
--       has_memory = true with has_memory = false.
--       **The plugin will not remember your settings if you do this**
has_memory = true;

arg = {
    SCALE    = 0, -- (Number) Amount to scale by
    SPACE    = 0, -- (Number) Number of padding pixels between images
    VERTICAL = 0, -- (Toggle) Whether to align images horizontally or vertically
};

if has_memory then
    run("libs/memory.lua");
    arg = memory.load(arg);
end

-- Get parameters from the user
OK, SCALE, SPACE, VERTICAL = inputbox("Zoom in Place",
"Scale Factor",  arg.SCALE,    2, 10,  0,
"Spacing",       arg.SPACE,    0, 100, 0,
"Vertical",      arg.VERTICAL, 0, 1,   0
);


if OK == true then
    -- Save selected parameters for next time
    if has_memory then
        memory.save({
            SCALE = SCALE,
            SPACE = SPACE,
            VERTICAL = VERTICAL
        });
    end

    frames = getlayercount();
    w,h = getpicturesize();

    -- Calculate the dimensions of the resulting image
    wfinal = (w * SCALE) + ((1 - VERTICAL) * (w + SPACE));
    hfinal = (h * SCALE) + (VERTICAL * (h + SPACE));

    -- Resize the page
    setpicturesize(wfinal, hfinal)

    -- Copy all frames to their corresponding locations
    for i = 0, frames - 1 do
        selectlayer(i);

        for y = 0, h - 1 do
            for x = 0, w - 1 do
                for yy = 0, SCALE - 1 do
                    for xx = 0, SCALE - 1 do
                        putpicturepixel((x * SCALE + xx) + ((1 - VERTICAL) * (w + SPACE)), (y * SCALE + yy) + (VERTICAL * (h + SPACE)), getlayerpixel(x, y));
                    end
                end
            end
        end
    end
end
