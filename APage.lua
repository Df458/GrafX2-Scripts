--Append Page v1.0 (Hugues Ross)
-- Appends contents of the second page to the
-- current page

-- Please direct all feedback, bug reports, and feature requests to
-- hugues.ross@gmail.com, and put the title of this script in the subject line.
-- Satisfaction guaranteed, or your (nonexistant) money back.

-- Note: The memory library is optional. If you don't have it, just replace
--       has_memory = true with has_memory = false.
--       **The plugin will not remember your settings if you do this**
has_memory = true;

arg = {
    SPACE    = 0, -- (Number) Number of padding pixels between images
    VERTICAL = 0, -- (Toggle) Whether to align images horizontally or vertically
};

if has_memory then
    run("libs/memory.lua");
    arg = memory.load(arg);
end

-- Get parameters from the user
OK, SPACE, VERTICAL = inputbox("Append Page",
"Spacing",       arg.SPACE,    0, 100, 0,
"Vertical",      arg.VERTICAL, 0, 1,   0
);


if OK == true then
    -- Save selected parameters for next time
    if has_memory then
        memory.save({
            SPACE = SPACE,
            VERTICAL = VERTICAL
        });
    end

    frames = getlayercount();
    frames2 = getsparelayercount();
    w,h = getpicturesize();
    w2,h2 = getsparepicturesize();
    trans = gettranscolor();

    -- Calculate the dimensions of the resulting image
    ox = (1 - VERTICAL) * (w + SPACE);
    oy = VERTICAL * (h + SPACE);
    if VERTICAL == 1 then
        wfinal = math.max(w, w2);
        hfinal = h + SPACE + h2;
    else
        wfinal = w + SPACE + w2;
        hfinal = math.max(h, h2);
    end

    -- Resize the page
    setpicturesize(wfinal, hfinal)

    -- Copy all frames to their corresponding locations
    for i = 0, frames2 - 1 do
        selectsparelayer(i);
        if i < frames then
            selectlayer(i);
        end

        for y = 0, h2 - 1 do
            for x = 0, w2 - 1 do
                pix = getsparelayerpixel(x, y);
                if i < frames or pix ~= trans then
                    putpicturepixel(ox + x, oy + y, pix);
                end
            end
        end
    end
end
