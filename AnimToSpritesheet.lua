--Animation to Spritesheet v1.0 (Hugues Ross)
-- Converts frames/layers on the current page into
-- a spritesheet on the second

-- Please direct all feedback, bug reports, and feature requests to
-- hugues.ross@gmail.com, and put the title of this script in the subject line.
-- Satisfaction guaranteed, or your (nonexistant) money back.

-- Note: The memory library is optional. If you don't have it, just replace
--       has_memory = true with has_memory = false.
--       **The plugin will not remember your settings if you do this**
has_memory = true;

arg = {
    CELLS    = 0, -- (Number) Maximum number of frames per row/column
    SPACE    = 0, -- (Number) Number of padding pixels between frames
    XOFF     = 0, -- (Number) X offset of the spritesheet
    YOFF     = 0, -- (Number) Y offset of the spritesheet
    VERTICAL = 0, -- (Toggle) Whether to align frames horizontally or vertically
    RESIZE   = 1  -- (Toggle) Whether or not to resize the second page
};

if has_memory then
    run("libs/memory.lua");
    arg = memory.load(arg);
end

frames = getlayercount();

-- Get parameters from the user. If there are so few frames that wrapping is
-- pointless, set CELLS to 0 and don't ask for it
if frames > 2 then
    OK, CELLS, SPACE, XOFF, YOFF, VERTICAL, RESIZE = inputbox("Generate Spritesheet",
    "Max Frames Per Row", arg.CELLS,    0, frames, 0,
    "Spacing",            arg.SPACE,    0, 100,    0,
    "X-offset",           arg.XOFF,     0, 800,    0,
    "Y-offset",           arg.YOFF,     0, 800,    0,
    "Vertical",           arg.VERTICAL, 0, 1,      0,
    "Resize Output",      arg.RESIZE,   0, 1,      0
    );
else
    CELLS = 0;

    OK, SPACE, XOFF, YOFF, VERTICAL, RESIZE = inputbox("Generate Spritesheet",
    "Spacing",       arg.SPACE,    0, 100, 0,
    "X-offset",      arg.XOFF,     0, 800, 0,
    "Y-offset",      arg.YOFF,     0, 800, 0,
    "Vertical",      arg.VERTICAL, 0, 1,   0,
    "Resize Output", arg.RESIZE,   0, 1,   0
    );
end


if OK == true then
    -- Save selected parameters for next time
    if has_memory then
        if frames > 2 then
            memory.save({
                CELLS = CELLS,
                SPACE = SPACE,
                XOFF = XOFF,
                YOFF = YOFF,
                VERTICAL = VERTICAL,
                RESIZE = RESIZE
            });
        else
            memory.save({
                SPACE = SPACE,
                XOFF = XOFF,
                YOFF = YOFF,
                VERTICAL = VERTICAL,
                RESIZE = RESIZE
            });
        end
    end

    w,h = getpicturesize();
    ws = w + SPACE;
    hs = h + SPACE;

    -- If the value is 0, we assume that the user wants 1 row/column
    if CELLS == 0 then
        CELLS = frames
    end

    -- Calculate the dimensions of the resulting spritesheet, including offsets
    wfinal = XOFF + w + ((1 - VERTICAL) * ws * (CELLS - 1)) + (VERTICAL * ws * (math.ceil(frames / CELLS) - 1));
    hfinal = YOFF + h + (VERTICAL * hs * (CELLS - 1)) + ((1 - VERTICAL) * hs * (math.ceil(frames / CELLS) - 1));

    -- Resize the second page, or perform bounds-checking
    if RESIZE == 1 then
        setsparepicturesize(wfinal, hfinal)
    else
        w2,h2 = getsparepicturesize();
        if w2 < wfinal or h2 < hfinal then
            messagebox("Can't Create Spritesheet", string.format("The second page is too small for this spritesheet, either select the resize option or resize the page to at least %dx%d.", wfinal, hfinal))
            return
        end
    end

    -- Copy all frames to their corresponding locations
    for i = 0, frames - 1 do
        selectlayer(i);

        for y = 0, h - 1 do
            for x = 0, w - 1 do
                putsparepicturepixel(XOFF + x + ((1 - VERTICAL) * ws * (i % CELLS)) + (VERTICAL * ws * math.floor(i / CELLS)), YOFF + y + (VERTICAL * hs * (i % CELLS)) + ((1 - VERTICAL) * hs * math.floor(i / CELLS)), getlayerpixel(x, y));
            end
        end
    end
end
